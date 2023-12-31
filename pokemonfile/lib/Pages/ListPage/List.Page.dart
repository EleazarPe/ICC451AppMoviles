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

  DatabaseHelper db = DatabaseHelper(); // Database
  bool loading = true; // If the Page is loading information.
  List<Pokemon> pokemons = []; // All Pokemons loaded in memory.
  int favoriteFilter = 0; // 0 all, 1 only favorite, -1 only not favorite Pokemons.
  String searchString = '';
  final GraphQLClient client = GraphQLClient(
        link: HttpLink('https://beta.pokeapi.co/graphql/v1beta'),
        cache: GraphQLCache(),
  );

  @override
  void initState() {
    super.initState();
    _loadPokemon();
  }

  @override
  Widget build(BuildContext context) {

    // Filtering the list
    List<Pokemon> displayedPokemons = _filterPokemons();

    return loading ?
      Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center (
                child: Image(
                  image: AssetImage("assets/gif/pikachu-running.gif"),
                  height: 75,
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(10.0),
                child: const Text("Loading..."),
              ),
            ],
          ),
        ),
      ) :

    Scaffold(
      appBar: _appBarList(),
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
  Future<void> _loadPokemon() async {

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

    try{
      var result = await client.query(options).whenComplete(() => print("Finished"));
      if (result.data != null){
        PokemonGraphQL pokemonGraphQL = PokemonGraphQL.fromJson(result.data!);
        pokemons = await db.updateDatabase(pokemonGraphQL);
        setState(() {
          loading = false;
        });
      }

    }catch(e){
      print("Error getting data");
    }

  }

  // Create app Bar for Page List
  AppBar _appBarList(){
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

  // Go to Details Page
  void _openPokemonDetails(BuildContext context, int id) {
    setState(() {});
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PokemonDetailsPage(id: id, onSonChanged: updatePokemonFromChild,)),
    );
  }

  // Change the favorite state in a pokemon in the list in memory
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

  // Filtrar los pokemones en memoria a los pokemones que se enseñaran en pantalla.
  List<Pokemon> _filterPokemons(){
    return pokemons.where((p) {

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
  }

}

