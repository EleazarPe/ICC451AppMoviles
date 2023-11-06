import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'DTO/PokeList.dart';
import 'Database/Database.dart';
import 'DTO/PokeOnly.dart';
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

class PokemonCard extends StatelessWidget {
  final Result pokemon;
  late  List<String> elementos = ["agua","fuego"] ;

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
                        imageUrl: 'https://github.com/Codeaamy/Pokedex/blob/master/images/pokeball.png?raw=true',
                      ),
                    ),
                    Center(
                      child: CachedNetworkImage(
                        imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${int.parse(pokemon.url.split('/')[6])}.png',
                        placeholder: (context, url) => Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red))),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#${int.parse(pokemon.url.split('/')[6])}  ',
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),Text(
                        pokemon.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: pokemon.pokemon?.types?.map((element) {
                          if (element != null) {
                            Color color = _getColorForElement(element.type.name);
                            Color textColor = textColorForBackground(color);
                            return Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  element.type.name,
                                  style: TextStyle(fontSize: 10.0, color: textColor),
                                ),
                              ),
                            );
                          } else {
                            return SizedBox(); // Widget de reemplazo si el elemento es nulo
                          }
                        })?.toList() ?? [],
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
  Color textColorForBackground(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
  Color _getColorForElement(String element) {
    if (element == 'fire') {
      return Colors.red;
    } else if (element == 'water') {
      return Colors.blue;
    } else if (element == 'grass') {
      return Colors.green;
    }else if(element == 'ice'){
      return Color.fromARGB(255,102,204,255);
    }else if(element == 'fairy'){
      return Color.fromARGB(255,238,153,238);
    }else if(element == 'electric'){
      return Color.fromARGB(255,255,204,51);
    }else if(element == 'fighting'){
      return Color.fromARGB(255,187,85,68);
    }else if(element == 'poison'){
      return Color.fromARGB(255,146,63,204);
    }else if(element == 'ground'){
      return Color.fromARGB(255,100,50,25);
    }else if(element == 'flying'){
      return Color.fromARGB(255,136,153,255);
    }else if(element == 'psychic'){
      return Color.fromARGB(255,255,85,153);
    }else if(element == 'bug'){
      return Color.fromARGB(255,170,187,34);
    }else if(element == 'rock'){
      return Color.fromARGB(255,170,170,153);
    }else if(element == 'ghost'){
      return Color.fromARGB(255,113,63,113);
    }else if(element == 'dragon'){
      return Color.fromARGB(255,79,96,226);
    } else if(element == 'dark'){
      return Color.fromARGB(255,79,63,61);
    } else if(element == 'steel'){
      return Color.fromARGB(255,96,162,185);
    } else if(element == 'normal'){
      return Color.fromARGB(255,170,170,153);
    }else{
      return Colors.white;
    }
  }
// List<String> getOnlyPokemon( String url){
//   PokeOnly? tempPokemons;
//   List<String> tipos = [];
//   http.get(Uri.parse(url)).then((response) {
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       tempPokemons = PokeOnly.fromJson(data);
//       tempPokemons?.types.forEach((element) {
//         tipos.add(element.type.name);
//       });
//
//     } else {
//       throw Exception('Failed to load pokemon type');
//     }
//   }).catchError((error) {
//     print('Error: $error');
//   });
//   return ["agua"];
// }
}
