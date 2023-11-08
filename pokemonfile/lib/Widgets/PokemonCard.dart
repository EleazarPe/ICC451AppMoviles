import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokemonfile/Model/Pokemon.dart';
import '../DTO/PokeList.dart';
import '../Database/Database.dart';
import '../DTO/PokeOnly.dart';

import '../Model/Pokemon.dart';

class PokemonCard extends StatefulWidget {
  final Result pokemon;
  final DatabaseHelper db = DatabaseHelper();

  PokemonCard({Key? key, required this.pokemon}) : super(key: key);

  @override
  State<PokemonCard> createState() => _PokemonCardState(pokemon: pokemon, db: db);
}

class _PokemonCardState extends State<PokemonCard> {
  late Result pokemon;
  late Pokemon pokemonDb;
  final DatabaseHelper db;
  late bool isFavorite = false; // Inicialización por defecto

  _PokemonCardState({
    required this.pokemon,
    required this.db,
  });

  @override
  void initState() {
    super.initState();
    obtainPokemonDb();
  }


  void obtainPokemonDb() async {
    List<Pokemon> pokemonList = await db.pokemonId(int.parse(pokemon.url.split('/')[6]));
    pokemonDb = pokemonList[0];
    isFavorite = pokemonDb.favorite == 1 ? true : false;
  }

  @override
  void didUpdateWidget(covariant PokemonCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pokemon != widget.pokemon) {
      pokemon = widget.pokemon;
      obtainPokemonDb();
    }
  }

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
              flex: 3,
              child: Container(
                color: const Color.fromARGB(255, 222, 222, 222),
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: Text(
                        '${int.parse(pokemon.url.split('/')[6])}',
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(5.0),
                      child: const Image(
                        image: AssetImage('assets/icons/game.png'),
                        opacity: AlwaysStoppedAnimation(.7),
                      ),
                    ),
                    Center(
                      child: CachedNetworkImage(
                        imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${int.parse(pokemon.url.split('/')[6])}.png',
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red))),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: isFavorite
                            ? const Icon(Icons.favorite_outlined, color: Colors.red)
                            : const Icon(Icons.favorite_border_outlined),
                        onPressed: () async {
                          await toggleFavorite();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pokemon.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: pokemon.pokemon?.types.map((element) {
                          if (element != null) {
                            Color color = getColorForElement(element.type.name);
                            Color textColor = textColorForBackground(color);
                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 3.0, right: 3.0, top: 5.0),
                                padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  element.type.name,
                                  style: TextStyle(color: textColor),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox();
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

  Future<void> toggleFavorite() async {
    List<Pokemon> pokemonSingle =  await db.changeFavorite(int.parse(pokemon.url.split('/')[6]));
    setState(() {
      isFavorite = pokemonSingle[0].favoriteBool();
    });
  }
}