import 'package:flutter/material.dart';

import '../../../../Model/Pokemon.dart';
import '../../../../Model/PokemonDetails.dart';

class TabEstadisticas extends StatelessWidget {

  final PokemonDetails pokemonDetails;

  const TabEstadisticas({super.key, required this.pokemonDetails});

  static const double _statsVerticalLength = 12.0;

  @override
  Widget build(BuildContext context) {
    return ListView(
        padding:
        const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0),
        children: [
          // Padding para String "Estadisticas"
          Container(
            padding: EdgeInsets.symmetric(vertical: 3.0),
            alignment: Alignment.center,
            // Const String "Stats"
            child: const Text(
              'Estadisticas',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // HP
          Container(
              padding: const EdgeInsets.symmetric(vertical: _statsVerticalLength),
              //padding: const EdgeInsets.symmetric(vertical: 5.0),

              child: Row(
                children: [
                  // String HP
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'HP',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Dato HP
                  Expanded(
                    flex: 1,
                    child: Text(
                      pokemonDetails.stats[0].baseStat.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Barra de HP
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 20,
                      child: ClipRRect(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10)),
                        child: LinearProgressIndicator(
                          value:
                          pokemonDetails.stats[0].baseStat / 255,
                          valueColor: AlwaysStoppedAnimation<Color>(getColorForElement(pokemonDetails.types[0])),
                          backgroundColor: const Color(0xffD6D6D6),
                        ),
                      ),
                    ),
                  ),
                ],
              )),

          // Attack
          Container(
              padding: const EdgeInsets.symmetric(
                  vertical: _statsVerticalLength),
              child: Row(
                children: [
                  // String Attack
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'Attack',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Dato Attack
                  Expanded(
                    flex: 1,
                    child: Text(
                      pokemonDetails.stats[1].baseStat.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Barra de Attack
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 20,
                      child: ClipRRect(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10)),
                        child: LinearProgressIndicator(
                          value:
                          pokemonDetails.stats[1].baseStat / 255,
                          valueColor: AlwaysStoppedAnimation<Color>(getColorForElement(pokemonDetails.types[0])),
                          backgroundColor: const Color(0xffD6D6D6),
                        ),
                      ),
                    ),
                  ),
                ],
              )),

          // Defense
          Container(
              padding: const EdgeInsets.symmetric(
                  vertical: _statsVerticalLength),
              child: Row(
                children: [
                  // String Defense
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'Defense',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Dato Defense
                  Expanded(
                    flex: 1,
                    child: Text(
                      pokemonDetails.stats[2].baseStat.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Barra de Defense
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 20,
                      child: ClipRRect(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10)),
                        child: LinearProgressIndicator(
                          value:
                          pokemonDetails.stats[2].baseStat / 255,
                          valueColor: AlwaysStoppedAnimation<Color>(getColorForElement(pokemonDetails.types[0])),
                          backgroundColor: const Color(0xffD6D6D6),
                        ),
                      ),
                    ),
                  ),
                ],
              )),

          // Special-Attack
          Container(
              padding: const EdgeInsets.symmetric(
                  vertical: _statsVerticalLength),
              child: Row(
                children: [
                  // String Special-Attack
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'Special Attack',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Dato Special-Attack
                  Expanded(
                    flex: 1,
                    child: Text(
                      pokemonDetails.stats[3].baseStat.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Barra de Special-Attack
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 20,
                      child: ClipRRect(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10)),
                        child: LinearProgressIndicator(
                          value: pokemonDetails.stats[3].baseStat / 255,
                          valueColor: AlwaysStoppedAnimation<Color>(getColorForElement(pokemonDetails.types[0])),
                          backgroundColor: const Color(0xffD6D6D6),
                        ),
                      ),
                    ),
                  ),
                ],
              )),

          // Special-Defense
          Container(
              padding: const EdgeInsets.symmetric(
                  vertical: _statsVerticalLength),
              child: Row(
                children: [
                  // String Special Defense
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'Special Defense',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Dato Special-Attack
                  Expanded(
                    flex: 1,
                    child: Text(
                      pokemonDetails.stats[4].baseStat.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Barra de Special-Attack
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 20,
                      child: ClipRRect(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10)),
                        child: LinearProgressIndicator(
                          value: pokemonDetails.stats[4].baseStat / 255,
                          valueColor: AlwaysStoppedAnimation<Color>(getColorForElement(pokemonDetails.types[0])),
                          backgroundColor: const Color(0xffD6D6D6),
                        ),
                      ),
                    ),
                  ),
                ],
              )),

          // Special-Defense
          Container(
              padding: const EdgeInsets.symmetric(
                  vertical: _statsVerticalLength),
              child: Row(
                children: [
                  // String Special Defense
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'Speed',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Dato Special-Attack
                  Expanded(
                    flex: 1,
                    child: Text(
                      pokemonDetails.stats[5].baseStat.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Barra de Special-Attack
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 20,
                      child: ClipRRect(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10)),
                        child: LinearProgressIndicator(
                          value:
                          pokemonDetails.stats[5].baseStat / 255,
                          valueColor: AlwaysStoppedAnimation<Color>(getColorForElement(pokemonDetails.types[0])),
                          backgroundColor: const Color(0xffD6D6D6),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ]);
  }
}
