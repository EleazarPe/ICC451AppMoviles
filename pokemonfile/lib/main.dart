import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'DTO/PokeList.dart';
import 'Database/Database.dart';
void main() {
  runApp(PokedexApp());
}

class PokedexApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.red, // Cambia el color de la AppBar a rojo
      ),
      home: PokedexScreen(),
    );
  }
}

class PokedexScreen extends StatefulWidget {
  @override
  _PokedexScreenState createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  final String apiUrl = "https://pokeapi.co/api/v2/pokemon?limit=60"; // Cambio en el límite inicial
  late PokeList pokemons = PokeList(results: [], count: 0, next: '', previous: '');
  late PokeList pokemonsTemp;
  DatabaseHelper db = DatabaseHelper();

  bool isLoading = false;
  ScrollController _scrollController = ScrollController();
  String searchString = '';

  @override
  void initState() {
    super.initState();
    fetchPokemons();
    allPokemons();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        fetchMorePokemons();
      }
    });
  }

  void fetchPokemons() {
    http.get(Uri.parse(apiUrl)).then((response) {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        PokeList tempPokemons = PokeList.fromJson(data);
        // for (var item in data['results']) {
        //   final name = item['name'];
        //   final url = item['url'];
        //   final pokemonId = int.parse(url.split('/')[6]);
        //   tempPokemons.add(Pokemon(name, pokemonId));
        // }
        setState(() {
          pokemons = tempPokemons;
        });
      } else {
        throw Exception('Failed to load pokemons');
      }
    }).catchError((error) {
      // Manejar errores si la petición falla
      print('Error: $error');
    });
  }

  void allPokemons() {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      http.get(Uri.parse("https://pokeapi.co/api/v2/pokemon?limit=5000"))
          .then((response) {
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          PokeList tempPokemons = PokeList.fromJson(data);
          setState(() {
            pokemonsTemp = tempPokemons;
            isLoading = false;
          });
        } else {
          throw Exception('Failed to load more pokemons');
        }
      }).catchError((error) {
        print('Error: $error');
      });
    }
  }

  Future<void> fetchMorePokemons() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      final response = await http.get(Uri.parse("https://pokeapi.co/api/v2/pokemon?limit=60&offset=${pokemons.results.length}")); // Carga 60 más
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        //List<dynamic> results = data['results'];
        PokeList tempPokemons = PokeList.fromJson(data);

        // for (var item in results) {
        //   // final name = item['name'];
        //   // final url = item['url'];
        //   // final pokemonId = int.parse(url.split('/')[6]);------------------------------>>>>>>>>>>>>>
        //   tempPokemons.add(Result(name: name, url: url));
        // }
        setState(() {
          pokemons.results.addAll(tempPokemons.results);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load more pokemons');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Result> displayedPokemons =  (searchString.isEmpty
        ? pokemons.results.where((pokemon) {
      final nameLower = pokemon.name.toLowerCase();
      final searchLower = searchString.toLowerCase();
      return nameLower.contains(searchLower) || (pokemon.url.split('/')[6])==searchLower;
    }).toList()
        : pokemonsTemp.results.where((pokemon) {
      final nameLower = pokemon.name.toLowerCase();
      final searchLower = searchString.toLowerCase();
      return nameLower.contains(searchLower) || (pokemon.url.split('/')[6])==searchLower;
    }).toList());
    // List<Result> displayedPokemons= [];
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokedex'),
        backgroundColor: Color.fromARGB(255, 202, 0, 16),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [

                Expanded(

                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar Pokémon',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchString = value;
                      });
                    },style: TextStyle(fontSize: 14.0),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: displayedPokemons.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(8),
                  child: GestureDetector(
                    onTap: () {
                      _openPokemonDetails(context, displayedPokemons[index]);
                    },
                    child: PokemonCard(
                      pokemon: displayedPokemons[index],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openPokemonDetails(BuildContext context, Result pokemon) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PokemonDetailsScreen(pokemon: pokemon)),
    );
  }
}

class PokemonDetailsScreen extends StatelessWidget {
  final Result pokemon;

  PokemonDetailsScreen({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name),
        backgroundColor: const Color.fromARGB(255, 202, 0, 16),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              pokemon.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'ID: ${int.parse(pokemon.url.split('/')[6])}',
              style: TextStyle(fontSize: 18),
            ),

          ],
        ),
      ),
    );
  }
}

class PokemonCard extends StatelessWidget {
  final Result pokemon;

  PokemonCard({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: const Color.fromARGB(255, 222, 222, 222),
                child: Stack(
                  children: [
                    Center(
                      child: CachedNetworkImage(
                        imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${int.parse(pokemon.url.split('/')[6])}.png',
                        //imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${int.parse(pokemon.url.split('/')[6])}.png',
                        placeholder: (context, url) => Center(child: CircularProgressIndicator( valueColor: AlwaysStoppedAnimation<Color>(Colors.red),)),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2, // Ocupa el 25% del espacio
              child: Container(
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pokemon.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${int.parse(pokemon.url.split('/')[6])}',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
