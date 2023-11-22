import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import '../../DTO/DTO.PokeList.dart';
import '../../Database/Database.dart';
import '../../DTO/DTO.PokemonOnly.dart';
import '../../Model/Pokemon.dart';
import 'ListCard.dart' as pc;
import '../DetailsPage/Details.Page.dart';


class PokemonListPage extends StatefulWidget {
  @override
  _PokemonListPageState createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {

  bool isLoading = false;

  final String apiUrl = "https://pokeapi.co/api/v2/pokemon?limit=50"; // Cambio en el límite inicial
  late PokeList pokemons = PokeList(results: [], count: 0, next: '', previous: '');
  late PokeList pokemonsTemp;
  late List<Pokemon> pokemonsDb;
  bool _favoriteFilter = false;
  DatabaseHelper db = DatabaseHelper();

  ScrollController _scrollController = ScrollController();
  String searchString = '';

  @override
  void initState() {
    super.initState();

    allPokemons();
    fetchPokemons();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.1) {
        fetchMorePokemons();
      }
    });

  }

  // Fetch Pokemons from db and API calls.
  void fetchPokemons() async{

    http.get(Uri.parse(apiUrl)).then((response) async {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        PokeList tempPokemons = PokeList.fromJson(data);
        for (var element in tempPokemons.results) {
          http.Response pokemonResponse = await http.get(Uri.parse(element.url));

          if (pokemonResponse.statusCode == 200) {
            final pokemonData = json.decode(pokemonResponse.body);
            element.pokemon = PokemonOnly.fromJson(pokemonData);
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
      print('Error: $error');
    });
  }

  // load all pokemons
  void allPokemons() {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      // API call para obtener la cantidad total de pokemones
      http.get(Uri.parse("https://pokeapi.co/api/v2/pokemon?limit=0")).then((response) async {
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          PokeList count = PokeList.fromJson(data);

          // API call para obtener la lista de todos los pokemones
          http.get(Uri.parse("https://pokeapi.co/api/v2/pokemon?limit=${count.count}")).then((response) async {
            if (response.statusCode == 200) {

              // Obtener la lista del Json
              final data = json.decode(response.body);
              pokemonsTemp = PokeList.fromJson(data);

              // Insertar y obtener los pokemones de la base de datos
              await db.insertAllPokemons(pokemonsTemp);
              pokemonsDb = await db.pokemonList();

              setState(() {
                isLoading = false;
              });

            } else {
              pokemonsDb = await db.pokemonList();
              throw Exception('Failed to make API call');
            }
          }).catchError((error) async {
            pokemonsDb = await db.pokemonList();
            print('Error: $error');
          });

        } else {
          throw Exception('Failed to make API call');
        }
      }).catchError((error) async {
        pokemonsDb = await db.pokemonList();
        print('Error: $error');
      });
    }
  }

  Future<void> fetchMorePokemons() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      final response = await http.get(Uri.parse("https://pokeapi.co/api/v2/pokemon?limit=100&offset=${pokemons.results.length}")); // Carga 50 mas
      if (response.statusCode == 200) {

        final data = json.decode(response.body);
        PokeList tempPokemons = PokeList.fromJson(data);

        setState(() {
          pokemons.results.addAll(tempPokemons.results);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load more pokemons');
      }
    }
  }

/*  Future<String> fetchPokemonData(String pokemonUrl) async {
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
  }*/

/*  Future<void> fetchAndSetPokemonData(Result pokemon) async {
    try {
      String pokemonData = await fetchPokemonData(pokemon.url);
      pokemon.pokemon = PokeOnly.fromJson(json.decode(pokemonData));
    } catch (error) {
      print('Error fetching Pokémon data: $error');
      // Manejo de errores
    }
  }*/
/*  Future<void> fetchAllPokemonData(List<Result> displayedPokemons) async {
    final futures = <Future>[];

    for (var pokemon in displayedPokemons) {
      if (pokemon.pokemon == null) {
        futures.add(fetchAndSetPokemonData(pokemon));
      }
    }

    await Future.wait(futures);
  }*/

  @override
  Widget build(BuildContext context) {

    List<Result> displayedPokemons =  (
        searchString.isEmpty ?

        pokemons.results.where((pokemon) {
          final nameLower = pokemon.name.toLowerCase();
          final searchLower = searchString.toLowerCase();
          bool favoriteDb = getPokemonId(pokemonsDb, int.parse(pokemon.url.split('/')[6])).favoriteBool();

          return (nameLower.contains(searchLower) || (pokemon.url.split('/')[6])==searchLower) && (_favoriteFilter == true ? favoriteDb ?? true : true);
        }).toList()

            : pokemonsTemp.results.where((pokemon) {
              final nameLower = pokemon.name.toLowerCase();
              final searchLower = searchString.toLowerCase();
              bool favoriteDb = getPokemonId(pokemonsDb, int.parse(pokemon.url.split('/')[6])).favoriteBool();

              return (nameLower.contains(searchLower) || (pokemon.url.split('/')[6])==searchLower) && (_favoriteFilter == true ? favoriteDb ?? true : true);

            }).toList()
    );
    if(searchString.isNotEmpty){
      //fetchAllPokemonData(displayedPokemons);
    }
    //fetchAllPokemonData(displayedPokemons);

    return
    Scaffold(
      appBar: appBarDefault(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [

                Expanded(

                  // Buscar Pokemon
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
                    },style: const TextStyle(fontSize: 14.0),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ],
            ),
          ),


          // Lista de Pokemon
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
                      _openPokemonDetails(context, getPokemonId(pokemonsDb, int.parse(displayedPokemons[index].url.split('/')[6])));
                    },

                    // Pokemon Card
                    child: pc.PokemonCard(
                      pokemon: displayedPokemons[index],
                      pokemonDB: getPokemonId(pokemonsDb, int.parse(displayedPokemons[index].url.split('/')[6])),
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

  // Push para ir a los detalles del pokemon
  void _openPokemonDetails(BuildContext context, Pokemon pokemon) {
    setState(() {});
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PokemonDetailsPage(pokemonDB: pokemon)),
    );
  }

  AppBar appBarDefault(){
    return AppBar(
      title: const Text('Pokedex'),
      backgroundColor: const Color.fromARGB(255, 202, 0, 16),
      actions: [

        IconButton(
            onPressed: () async {
              _favoriteFilter = !_favoriteFilter;
              await getPokemonDB();
              setState(() {

              });
              },
            icon: _favoriteFilter ?
            const Icon(Icons.favorite_outlined, color: Colors.red,) :
            const Icon(Icons.favorite_border)
        ),
      ],
    );
  }

  Future<void> getPokemonDB() async {
    List<Pokemon> list = await db.pokemonList();
    setState(() {
      pokemonsDb = list;
    });
  }


}

