import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokemonfile/Model/Pokemon.dart';
import '../DTO/PokeList.dart';
import '../Database/Database.dart';
import '../DTO/PokeOnly.dart';

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
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            child: Text(
                              '${int.parse(pokemon.url.split('/')[6])}',
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),

                          // Imagen de Pokeball en el bg
                          Center(
                            child: CachedNetworkImage(
                              imageUrl: 'https://github.com/Codeaamy/Pokedex/blob/master/images/pokeball.png?raw=true',
                            ),
                          ),

                          // Imagen de Pokemon
                          Center(
                            child: CachedNetworkImage(
                              imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${int.parse(pokemon.url.split('/')[6])}.png',
                              placeholder: (context, url) => Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red))),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),

                          // Icono de Favorito
                          Container(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: (snapshot.data?? false) ?
                              new Icon(Icons.favorite_outlined, color: Colors.red,) :
                              new Icon(Icons.favorite_border_outlined) ,

                              onPressed: () async {

                                await db.changeFavorite(int.parse(pokemon.url.split('/')[6]));

                                setState(() {

                                });

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
                              children: pokemon.pokemon?.types?.map((element) {
                                if (element != null) {
                                  Color color = _getColorForElement(element.type.name);
                                  Color textColor = textColorForBackground(color);
                                  return Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 3.0, right: 3.0, top: 5.0),
                                      padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
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


  Color textColorForBackground(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  Color _getColorForElement(String element) {
    if (element == 'fire') {
      return Colors.red;
    } else if (element == 'water') {
      return Colors.blue;
    } else if (element == 'grass') {
      return Colors.green;
    }else if(element == 'ice'){
      return Color.fromARGB(255,102,204,255);
    }else if(element == 'fairy'){
      return Color.fromARGB(255,238,153,238);
    }else if(element == 'electric'){
      return Color.fromARGB(255,255,204,51);
    }else if(element == 'fighting'){
      return Color.fromARGB(255,187,85,68);
    }else if(element == 'poison'){
      return Color.fromARGB(255,146,63,204);
    }else if(element == 'ground'){
      return Color.fromARGB(255,100,50,25);
    }else if(element == 'flying'){
      return Color.fromARGB(255,136,153,255);
    }else if(element == 'psychic'){
      return Color.fromARGB(255,255,85,153);
    }else if(element == 'bug'){
      return Color.fromARGB(255,170,187,34);
    }else if(element == 'rock'){
      return Color.fromARGB(255,170,170,153);
    }else if(element == 'ghost'){
      return Color.fromARGB(255,113,63,113);
    }else if(element == 'dragon'){
      return Color.fromARGB(255,79,96,226);
    } else if(element == 'dark'){
      return Color.fromARGB(255,79,63,61);
    } else if(element == 'steel'){
      return Color.fromARGB(255,96,162,185);
    } else if(element == 'normal'){
      return Color.fromARGB(255,170,170,153);
    }else{
      return Colors.white;
    }
  }
}
