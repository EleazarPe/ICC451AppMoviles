import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'DTO/PokeList.dart';
import 'Database/Database.dart';
import 'DTO/PokeOnly.dart';
import 'Widgets/PokemonCard.dart' as pc;
import 'Page/PokemonListPage.dart';


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
      home: PokemonListPage(),
    );
  }
}