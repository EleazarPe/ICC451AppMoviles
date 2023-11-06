import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'DTO/PokeList.dart';
import 'Database/Database.dart';
import 'DTO/PokeOnly.dart';
import 'Widgets/PokemonCard.dart' as pc;
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
  final String apiUrl = "https://pokeapi.co/api/v2/pokemon?limit=50"; // Cambio en el límite inicial
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
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.1) {
        fetchMorePokemons();
      }
    });

  }


  void fetchPokemons() async{
    http.get(Uri.parse(apiUrl)).then((response) async {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        PokeList tempPokemons = PokeList.fromJson(data);
        for (var element in tempPokemons.results) {
          http.Response pokemonResponse = await http.get(Uri.parse(element.url));

          if (pokemonResponse.statusCode == 200) {
            final pokemonData = json.decode(pokemonResponse.body);
            element.pokemon = PokeOnly.fromJson(pokemonData);
          } else {
            throw Exception('Failed to load pokemon info');
          }
        }
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

      final response = await http.get(Uri.parse("https://pokeapi.co/api/v2/pokemon?limit=50&offset=${pokemons.results.length}")); // Carga 60 más
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        //List<dynamic> results = data['results'];
        PokeList tempPokemons = PokeList.fromJson(data);
        int temp =0;
        for (var element in tempPokemons.results) {
          http.Response pokemonResponse = await http.get(Uri.parse(element.url));

          if (pokemonResponse.statusCode == 200) {
            final pokemonData = json.decode(pokemonResponse.body);
            element.pokemon = PokeOnly.fromJson(pokemonData);
          } else {
            throw Exception('Failed to load pokemon info');
          }
          print(temp);
          temp++;
        }
        setState(() {
          pokemons.results.addAll(tempPokemons.results);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load more pokemons');
      }
    }
  }
  Future<String> fetchPokemonData(String pokemonUrl) async {
    try {
      http.Response pokemonResponse = await http.get(Uri.parse(pokemonUrl));
      if (pokemonResponse.statusCode == 200) {
        return pokemonResponse.body;
      } else {
        throw Exception('Failed to load Pokemon info');
      }
    } catch (error) {
      print('Error: $error');
      return '';
    }
  }

  Future<void> fetchAndSetPokemonData(Result pokemon) async {
    try {
      String pokemonData = await fetchPokemonData(pokemon.url);
      pokemon.pokemon = PokeOnly.fromJson(json.decode(pokemonData));
    } catch (error) {
      print('Error fetching Pokémon data: $error');
      // Manejo de errores
    }
  }
  Future<void> fetchAllPokemonData(List<Result> displayedPokemons) async {
    final futures = <Future>[];

    for (var pokemon in displayedPokemons) {
      if (pokemon.pokemon == null) {
        futures.add(fetchAndSetPokemonData(pokemon));
      }
    }

    await Future.wait(futures);
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
    fetchAllPokemonData(displayedPokemons);
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
                    child: pc.PokemonCard(
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

class PokemonDetailsScreen extends StatefulWidget {
  final Result pokemon;

  PokemonDetailsScreen({required this.pokemon});

  @override
  _PokemonDetailsScreenState createState() => _PokemonDetailsScreenState();
}

class _PokemonDetailsScreenState extends State<PokemonDetailsScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pokemon.name),
        backgroundColor: const Color.fromARGB(255, 202, 0, 16),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 200, // Ajusta el tamaño según la imagen del Pokémon
            child: Center(
              child: Image.network(
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${int.parse(widget.pokemon.url.split('/')[6])}.png',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavigationItem(0, 'Información'),
                _buildNavigationItem(1, 'Estadísticas'),
                _buildNavigationItem(2, 'Evoluciones'),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                _buildSection('Información'),
                _buildSection('Estadísticas'),
                _buildSection('Evoluciones'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItem(int index, String title) {
    return TextButton(
      onPressed: () {
        setState(() {
          _currentPage = index;
          _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.ease);
        });
      },
      child: Text(
        title,
        style: TextStyle(fontSize: 16),
      ),
      style: TextButton.styleFrom(primary: _currentPage == index ? Colors.blue : Colors.grey),
    );
  }

  Widget _buildSection(String sectionName) {
    return Center(
      child: Text(
        sectionName,
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}