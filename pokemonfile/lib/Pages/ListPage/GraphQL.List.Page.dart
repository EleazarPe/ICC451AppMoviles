import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokemonfile/DTO/DTO.PokemonGraphQL.dart';
import 'package:pokemonfile/Pages/ListPage/List.Page.dart';
import '../../DTO/DTO.PokeList.dart';
import '../../Database/Database.dart';
import '../../DTO/DTO.PokemonOnly.dart';
import '../../Model/Pokemon.dart';
import 'ListCard.dart' as pc;
import '../DetailsPage/Details.Page.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


class newListPage extends StatefulWidget {
  const newListPage({super.key});

  @override
  State<newListPage> createState() => _newListPageState();
}

class _newListPageState extends State<newListPage> {

  List<Pokemon> pokemons = []; // All Pokemons loaded in memory.
  List<Pokemon> displayedPokemos = []; // Pokemons that will be shown in the list.
  bool loading = true; // If the Page is loading information.
  int favoriteFilter = 0; // 0 all, 1 only favorite, -1 only not favorite Pokemons.

  final GraphQLClient client = GraphQLClient(
        link: HttpLink('https://beta.pokeapi.co/graphql/v1beta'),
        cache: GraphQLCache(),
      );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPokemon();

  }

  @override
  Widget build(BuildContext context) {

    return const Placeholder();
  }


  Future<void> loadPokemon() async {
    const String queryPokemons = r'''
query samplePokeAPIquery {
  pokemon_v2_pokemon(limit: 1){
    id
    name
    pokemon_v2_pokemontypes {
      pokemon_v2_type {
        id
        name
      }
    }
  }
}
''';

    QueryOptions options = QueryOptions(document: gql(queryPokemons));

    QueryResult result = await client.query(options);

    if(result.hasException){
      print("Could Not Fetch List Pokemon Data from API");
    }else{
      if (result == null){
        print("Could Not Fetch List Pokemon Data from API");
        return;
      }
      if (result.data != null){
        Map<String, dynamic> data = result.data!;
        PokemonGraphQL pokemonGraphQL = PokemonGraphQL.fromJson(data);
        print(pokemonGraphQL);
      }
    }

  }


}

