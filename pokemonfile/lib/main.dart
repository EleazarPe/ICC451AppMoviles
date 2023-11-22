import 'package:flutter/material.dart';
import 'Pages/ListPage/ListPage.dart';


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