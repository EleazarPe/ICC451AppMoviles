import 'package:flutter/material.dart';
import '../../../../Model/Pokemon.dart';
import '../../../../Model/PokemonDetails.dart';

class TabInformacion extends StatelessWidget {

  final PokemonDetails pokemonDetails;

  const TabInformacion({super.key, required this.pokemonDetails});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding:
      const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0),
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 3.0),
          alignment: Alignment.center,
          // Const String "Stats"
          child: const Text(
            'Información',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Padding los tipos del pokemon
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: Row(
            children: [
              // Const String Tipo
              const Expanded(
                flex: 1,
                child: Text(
                  'Tipo',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Los boxes con los tipos de pokemon
              Expanded(
                flex: 2,
                child: Row(
                  children: pokemonDetails.types.map((element) {
                    Color color = getColorForElement(element);
                    Color textColor = textColorForBackground(color);
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 3.0, right: 3.0, top: 5.0),
                        padding: const EdgeInsets.only(
                            top: 6.0, bottom: 6.0),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          element,
                          style: TextStyle(color: textColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList() ??
                      [],
                ),
              ),
            ],
          ),
        ),

        // Texto de Caracteristicas
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10),
          child: const Text(
            'Caracteristicas',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Padding para las caracteristicas del pokemon
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: Column(
            children: [
              // Informacion de la Altura
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Contenedor con la imagen de Altura
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    child: const Image(
                      image: AssetImage('assets/icons/measuring.png'),
                      height: 32.0,
                    ),
                  ),

                  // Texto constante "Altura"
                  const Text(
                    'Altura',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Informacion de la Altura
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 5.0),
                      alignment: Alignment.centerRight,
                      child: Text(
                        pokemonDetails.height.toString(),
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Informacion del Peso
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Contenedor con la imagen de Altura
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    child: const Image(
                      image: AssetImage('assets/icons/weight.png'),
                      height: 32.0,
                    ),
                  ),

                  // Texto constante "Altura"
                  const Text(
                    'Peso',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Informacion de la Altura
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 5.0),
                      alignment: Alignment.centerRight,
                      child: Text(
                        pokemonDetails.weight.toString(),
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Habilidades

        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10),
          child: const Text(
            'Habilidades',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: Column(
            children: pokemonDetails.abilities.map((e) {

              return Container(
                margin: const EdgeInsets.only(right: 5.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  " - $e",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );

            }).toList(),
          ),
        ),
      ],
    );
  }
}
