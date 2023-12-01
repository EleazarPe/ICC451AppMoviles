import 'package:flutter/material.dart';
import 'package:pokemonfile/DTO/DTO.PokemonGraphQL.dart';
import '../../Database/Database.dart';
import '../../Model/Pokemon.dart';
import 'List.Card.dart' as pc;
import '../DetailsPage/Details.Page.dart';
import 'package:graphql/client.dart';


class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {



  DatabaseHelper db = DatabaseHelper();

  List<Pokemon> pokemons = []; // All Pokemons loaded in memory.
  //List<Pokemon> displayedPokemons = []; // Pokemons that will be shown in the list.
  bool loading = true; // If the Page is loading information.
  int favoriteFilter = 0; // 0 all, 1 only favorite, -1 only not favorite Pokemons.

  ScrollController _scrollController = ScrollController();
  String searchString = '';
  int id = 0;

  final GraphQLClient client = GraphQLClient(
        link: HttpLink('https://beta.pokeapi.co/graphql/v1beta'),
        cache: GraphQLCache(),
      );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPokemon();

    /*_scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.1) {
        // Load more pokemons to the viewer
      }
    });*/
  }

  @override
  Widget build(BuildContext context) {

    // Filtering the list
    List<Pokemon> displayedPokemons = pokemons.where((p) {

      // checking favorite Filter
      bool favorite = true;
      switch (favoriteFilter){
        case 1: {
          favorite = p.favoriteBool() == true;
        }
        case -1: {
          favorite = p.favoriteBool() == false;
        }
        default: {
          favorite = true;
        }
      }

      // Checking search filter
      bool search = true;
      if (searchString.isEmpty){
        search = true;
      }
      else{
        String nameLower = p.name.toLowerCase();
        String searchLower = searchString.toLowerCase();
        search = nameLower.contains(searchLower) || p.id.toString() == searchString;
      }

      return favorite && search;

    }).toList();

    return
      Scaffold(
      appBar: appBarList(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.grey[200], // Color gris claro
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Buscar Pokémon',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchString = value;
                        });
                      },
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ), Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ) ,
                ],
              ),
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
                  padding: EdgeInsets.all(4),
                  child: GestureDetector(
                    onTap: () {
                      _openPokemonDetails(context, displayedPokemons[index].id);
                    },

                    // Pokemon Card
                    child: pc.PokemonCard(
                      onSonChanged: updatePokemonFromChild,
                      pokemon: getPokemonId(pokemons, displayedPokemons[index].id),
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


  // Get and load all pokemons
  Future<void> loadPokemon() async {

    HttpLink httpLink = HttpLink('https://beta.pokeapi.co/graphql/v1beta');

    GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: httpLink,
    );

    const String queryPokemons = r'''
query samplePokeAPIquery {
  pokemon_v2_pokemon{
    id
    name
    pokemon_v2_pokemontypes {
      pokemon_v2_type {
        id
        name
      }
    }
    pokemon_v2_pokemonsprites {
      sprites
    }
  }
}
''';
    QueryOptions options = QueryOptions(
      document: gql(queryPokemons),
    );

    var result = await client.query(options).whenComplete(() => print("Finished"));
    PokemonGraphQL pokemonGraphQL = PokemonGraphQL.fromJson(result.data!);

    pokemons = await db.updateDatabase(pokemonGraphQL);
    setState(() {
      loading = false;
    });
  }

  AppBar appBarList(){
    return AppBar(
      title: const Text('Pokedex'),
      backgroundColor: const Color.fromARGB(255, 202, 0, 16),
      actions: [

        IconButton(
            onPressed: () async {
              switch (favoriteFilter) {
                case 1: {
                  favoriteFilter = 0;
                }
                case 0: {
                  favoriteFilter = 1;
                }

              }
              setState(() {});
            },
            icon: favoriteFilter == 1 ?
            const Icon(Icons.favorite_outlined, color: Colors.red,) :
            const Icon(Icons.favorite_border)
        ),
      ],
    );
  }

  void _openPokemonDetails(BuildContext context, int id) {
    setState(() {});
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PokemonDetailsPage(id: id, onSonChanged: updatePokemonFromChild,)),
    );
  }

  void updatePokemonFromChild(int id, int favorite) {
    for(int i = 0 ; i < pokemons.length ; i ++){
      if (pokemons[i].id == id){
        setState(() {
          pokemons[i].favorite = favorite;
        });
        return;
      }
    }
  }


}

