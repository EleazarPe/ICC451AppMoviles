import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import '../DTO/PokeList.dart';
import '../Database/Database.dart';
import '../DTO/PokeOnly.dart';

import '../Model/Pokemon.dart';

class PokemonCard extends StatefulWidget {
  final Result pokemon;
  final Pokemon pokemonDB;
  final DatabaseHelper db = DatabaseHelper();

  PokemonCard({Key? key, required this.pokemon, required this.pokemonDB}) : super(key: key);

  @override
  State<PokemonCard> createState() =>
      _PokemonCardState(
        db: db,
        pokemon: pokemon,
        pokemonDb: pokemonDB,
      );
}

class _PokemonCardState extends State<PokemonCard> {

  final DatabaseHelper db;
  late Result pokemon;
  late Pokemon pokemonDb;

  _PokemonCardState({
    required this.db,
    required this.pokemon,
    required this.pokemonDb
  });

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PokemonCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pokemon != widget.pokemon || oldWidget.pokemonDB != widget.pokemonDB) {
      pokemon = widget.pokemon;
      pokemonDb = widget.pokemonDB;
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
                        '${pokemonDb.id}',
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
                        imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${pokemonDb.id}.png',
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red))),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: pokemonDb.favoriteBool()
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
                        pokemonDb.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Show the pokemon type
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: boxPokemonType(),
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
    await db.changeFavorite(pokemonDb.id);
    List<Pokemon> pokemonSingle = await db.pokemonId(pokemonDb.id);
    setState(() {
      pokemonDb.favorite = pokemonSingle[0].favorite;
    });
  }

  List<Widget> boxPokemonTypeTemp(){

    return pokemon.pokemon?.types.map((element) {
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
    }).toList() ?? [];
  }

  // Create the boxes for pokemon types
  List<Widget> boxPokemonType(){

    List<Widget> ret = [];

    // If types arent loaded
    if(pokemonDb.type1 == ""){
      ret.add(
        Container(
          child: Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 3.0, right: 3.0, top: 5.0),
              padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8.0),

              ),
              child: const Text(
                'loading...',
                style: TextStyle(
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          ));
      return ret;
    }

    // If types are loaded
    else{
      Color color = getColorForElement(pokemonDb.type1);
      Color textColor = textColorForBackground(color);
      ret.add(Expanded(
        child: Container(
          margin: const EdgeInsets.only(left: 3.0, right: 3.0, top: 5.0),
          padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            pokemonDb.type1,
            style: TextStyle(color: textColor),
            textAlign: TextAlign.center,
          ),
        ),
      ));
    }

    // If there exists a type2
    if (pokemonDb.type2 != ""){
      Color color = getColorForElement(pokemonDb.type2);
      Color textColor = textColorForBackground(color);
      ret.add(Expanded(
        child: Container(
          margin: const EdgeInsets.only(left: 3.0, right: 3.0, top: 5.0),
          padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            pokemonDb.type2,
            style: TextStyle(color: textColor),
            textAlign: TextAlign.center,
          ),
        ),
      ));
    }

    return ret;
  }

}