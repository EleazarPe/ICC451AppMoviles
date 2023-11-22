import 'package:flutter/material.dart';

import '../../../../Model/PokemonDetails.dart';

class TabMovimientos extends StatelessWidget {

  final PokemonDetails pokemonDetails;

  const TabMovimientos({super.key, required this.pokemonDetails});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Padding(
        padding: EdgeInsets.only(left: 10.0, right: 13.0, bottom: 8.0),

        // Const String "Stats"
        child: Text(
          'Movimientos',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Expanded(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            controller: ScrollController(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(5.0),
            itemCount: pokemonDetails.moves.length,
            itemBuilder: (context, index) {
              return Card(
                  elevation: 4,
                  child: Container(
                    padding: const EdgeInsets.only(
                        right: 10.0, left: 10.0, top: 10.0, bottom: 10.0),
                    child: Text(
                      pokemonDetails.moves[index].name,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ));
            }),
      ),
    ]);
  }
}
