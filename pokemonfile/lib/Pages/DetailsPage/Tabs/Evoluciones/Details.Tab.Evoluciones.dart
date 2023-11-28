import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../Model/PokemonDetails.dart';

class TabEvoluciones extends StatelessWidget {

  final PokemonDetails pokemonDetails;

  const TabEvoluciones({super.key, required this.pokemonDetails});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Padding(
        padding: EdgeInsets.only(left: 10.0, right: 13.0, bottom: 8.0),

        // Const String "Stats"
        child: Text(
          'Evoluciones',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Expanded(
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(15.0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: pokemonDetails.evolutionChain.map((e) {return createEvoluciones(e);}).toList(),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget createEvoluciones(Evolution evolution){

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        evolutionContainer(evolution),
        evolution.evolvesTo.isEmpty ? Container() : const Icon(Icons.arrow_forward),
        Column(
          children: evolution.evolvesTo.map((e) {
            return createEvoluciones(e);
          }).toList(),
        ),
      ],
    );
  }

  Widget evolutionContainer(Evolution evolution){

    return Container(
      margin: EdgeInsets.all(10.0),
      height: 100,
      alignment: Alignment.center,
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                print(evolution.name);
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(5.0),
                child: CachedNetworkImage(
                  imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${evolution.id}.png',
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red))),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Text(evolution.name),
          ),
        ],
      ),
    );
  }



}
