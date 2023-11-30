import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../Model/PokemonDetails.dart';
import '../../Details.Page.dart';

typedef PokemonCallBack = void Function(int id, int favorite);

class TabEvoluciones extends StatefulWidget {

  final PokemonDetails pokemonDetails;
  final PokemonCallBack onSonChanged;

  const TabEvoluciones({super.key,
    required this.pokemonDetails,
    required this.onSonChanged,
  });

  @override
  State<TabEvoluciones> createState() => _TabEvolucionesState(pokemonDetails: pokemonDetails, onSonChanged: onSonChanged);
}

class _TabEvolucionesState extends State<TabEvoluciones> {

  final PokemonDetails pokemonDetails;
  final PokemonCallBack onSonChanged;

  _TabEvolucionesState({
    required this.pokemonDetails,
    required this.onSonChanged,
  });


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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (pokemonDetails.id != evolution.id){
                  _openPokemonDetails(context, evolution.id);
                }
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(5.0),
                child: Stack(
                  children: [
                    Center(
                      child: CachedNetworkImage(
                        imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${evolution.id}.png',
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red))),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),

                    // Nivel minimo
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(evolution.minLevel != null ? "LV ${evolution.minLevel.toString()}" : "",),
                    )
                  ],
                )
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

  void _openPokemonDetails(BuildContext context, int id) {
    setState(() {});
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PokemonDetailsPage(id: id, onSonChanged: onSonChanged)),
    );
  }

}


/*
class TabEvoluciones extends StatelessWidget {

  final PokemonDetails pokemonDetails;
  final PokemonCallBack onSonChanged;

  const TabEvoluciones({
    super.key,
    required this.pokemonDetails,
    required this.onSonChanged,
  });

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
                if (pokemonDetails.id != evolution.id){

                }
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

  void _openPokemonDetails(BuildContext context, int id) {
    setState(() {});
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PokemonDetailsPage(id: id, onSonChanged: onSonChanged)),
    );
  }

}
*/
