import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokemonfile/Pages/ListPage/List.Page.dart';
import '../../DTO/DTO.PokeList.dart';
import '../../Database/Database.dart';
import '../../DTO/DTO.PokemonOnly.dart';
import '../../Model/Pokemon.dart';
import 'ListCard.dart' as pc;
import '../DetailsPage/Details.Page.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


class GraphQLListPage extends StatefulWidget {
  const GraphQLListPage({super.key});

  @override
  State<GraphQLListPage> createState() => _GraphQLListPage();
}

class _GraphQLListPage extends State<GraphQLListPage> {

  final GraphQLClient client = GraphQLClient(
    link: HttpLink('https://beta.pokeapi.co/graphql/v1beta'),
    cache: GraphQLCache(),
  );

  late final ValueNotifier<GraphQLClient> clientNotifier = ValueNotifier<GraphQLClient>(client);


  @override
  Widget build(BuildContext context) {



    return GraphQLProvider(
      client: clientNotifier,
      child: ListPage(),
    );
  }
}

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

