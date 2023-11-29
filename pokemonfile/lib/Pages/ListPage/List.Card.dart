import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import '../../Database/Database.dart';
import '../../DTO/DTO.PokemonOnly.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../Model/Pokemon.dart';

typedef PokemonCallBack = void Function(int id, int favorite);

class PokemonCard extends StatefulWidget {

  final PokemonCallBack onSonChanged;

  final Pokemon pokemon;
  final DatabaseHelper db = DatabaseHelper();

  PokemonCard({Key? key, required this.pokemon, required this.onSonChanged}) : super(key: key);

  @override
  State<PokemonCard> createState() =>
      _PokemonCardState(
        onSonChanged: onSonChanged,
        db: db,
        pokemon: pokemon,
      );
}

class _PokemonCardState extends State<PokemonCard> {

  final PokemonCallBack onSonChanged;

  final DatabaseHelper db;
  late Pokemon pokemon;

  _PokemonCardState({
    required this.onSonChanged,
    required this.db,
    required this.pokemon,
  });

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PokemonCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pokemon != widget.pokemon) {
      pokemon = widget.pokemon;
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
                        '${pokemon.id}',
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
                      child: pokemon.sprites.isNotEmpty ?
                      CachedNetworkImage(
                        imageUrl: pokemon.sprites[0],
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red))),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ) :
                      const Icon(Icons.error)
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: pokemon.favoriteBool()
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
                      Expanded(
                        flex: 1,
                        child: AutoSizeText(
                          pokemon.name,
                          minFontSize: 12,
                          maxFontSize: 24,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ),
                      Expanded(
                        flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: boxPokemonType(),
                          ),
                      ), // Show the pokemon type
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
    List<Pokemon> poke = await db.changeFavorite(pokemon.id);
    setState(() {
      pokemon.favorite = poke[0].favorite;
      onSonChanged(pokemon.id, pokemon.favorite);
    });
  }

  // Create the boxes for pokemon types
  List<Widget> boxPokemonType(){

    List<Widget> ret = [];

    // If types arent loaded
    if(pokemon.type1 == ""){
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
      Color color = getColorForElement(pokemon.type1);
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
            pokemon.type1,
            style: TextStyle(color: textColor),
            textAlign: TextAlign.center,
          ),
        ),
      ));
    }

    // If there exists a type2
    if (pokemon.type2 != ""){
      Color color = getColorForElement(pokemon.type2);
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
            pokemon.type2,
            style: TextStyle(color: textColor),
            textAlign: TextAlign.center,
          ),
        ),
      ));
    }

    return ret;
  }

/*  // Obtener una nueva informacion del pokemon y hacer un set state
  Future<void> updatePokemonInfo() async {
    List<Pokemon> pokemonSingle = await db.pokemonId(pokemon.id);
    setState(() {
      pokemon = pokemonSingle[0];
    });
  }*/



}