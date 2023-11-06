import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import '../DTO/PokeList.dart';
import '../Database/Database.dart';
import '../DTO/PokeOnly.dart';
import '../Widgets/PokemonCard.dart' as pc;

class PokemonDetailsPage extends StatefulWidget {
  final Result pokemon;

  PokemonDetailsPage({required this.pokemon});

  @override
  _PokemonDetailsPageState createState() => _PokemonDetailsPageState();
}

class _PokemonDetailsPageState extends State<PokemonDetailsPage> {
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