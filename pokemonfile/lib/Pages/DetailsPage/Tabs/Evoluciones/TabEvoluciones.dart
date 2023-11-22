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
          padding: EdgeInsets.all(15.0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: pokemonDetails.evolutionChain.map((e) {return createEvoluciones(e);}).toList(),
                )
              ],
            ),
          ],
        ),
      ),
    ]);
  }

  Widget createEvoluciones(Evolution evolution){

    return Row(

      children: [

        Container(
          margin: EdgeInsets.all(10.0),
          alignment: Alignment.center,
          child: Text(evolution.name),
        ),

        Column(
          children: evolution.evolvesTo.map((e) {
            return createEvoluciones(e);
          }).toList(),
        ),
      ],
    );
  }

}
