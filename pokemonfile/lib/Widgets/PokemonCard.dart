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

  PokemonCard({super.key, required this.pokemon});

  @override
  State<PokemonCard> createState() => _PokemonCardState(pokemon: pokemon, db: db);

}

class _PokemonCardState extends State<PokemonCard> {

  final Result pokemon;
  final DatabaseHelper db;

  _PokemonCardState({
    required this.pokemon,
    required this.db,
  });

  @override
  Widget build(BuildContext context) {



    return FutureBuilder(
        future: db.isFavorite(int.parse(pokemon.url.split('/')[6])),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {

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

                          // Numero de Pokemon
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

                          // Imagen de Pokeball en el bg
                          Container(

                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(5.0),

                            child: const Image(
                              image: AssetImage('assets/icons/game.png'),
                              opacity: AlwaysStoppedAnimation(.7),
                            ),
                          ),

                          // Imagen de Pokemon
                          Center(
                            child: CachedNetworkImage(
                              imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${int.parse(pokemon.url.split('/')[6])}.png',
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red))),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),

                          // Icono de Favorito
                          Container(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: (snapshot.data?? false) ?
                              const Icon(Icons.favorite_outlined, color: Colors.red,) :
                              const Icon(Icons.favorite_border_outlined) ,

                              onPressed: () async {
                                await db.changeFavorite(int.parse(pokemon.url.split('/')[6]));
                                setState(() {});

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
                                  return const SizedBox(); // Widget de reemplazo si el elemento es nulo
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
          },
    );
  }

}
