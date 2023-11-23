import 'package:pokemonfile/DTO/DTO.PokemonOnly.dart' as PO;
import 'package:pokemonfile/DTO/DTO.PokemonSpecies.dart' as PS;

import '../DTO/DTO.EvolutionChain.dart' as EC;
import '../DTO/DTO.EvolutionChain.dart';

class PokemonDetails {

  // PokeOnly
  int id;
  String name;
  List<String> types;
  int height;
  int weight;
  List<Stat> stats;
  List<String> sprites;
  List<Move> moves;

  // PokemonSpecies
  int baseHappiness;
  int captureRate;
  String generation;
  String growthRate;
  int hatchCounter;
  String flavorText;

  // EvolutionChain
  List<Evolution> evolutionChain;

  PokemonDetails({

    // PokeOnly
    required this.id,
    required this.name,
    required this.types,
    required this.height,
    required this.weight,
    required this.stats,
    required this.sprites,
    required this.moves,

    // PokemonSpecies
    required this.baseHappiness,
    required this.captureRate,
    required this.generation,
    required this.growthRate,
    required this.hatchCounter,
    required this.flavorText,
    
    // EvolutionChain
    required this.evolutionChain,

  });

}

// Funcion privada para traducir de los DTO a la clase que se usara en la applicacion (para abstraccion)
PokemonDetails injectDetails(PO.PokemonOnly pokemonOnly, PS.PokemonSpecies pokemonSpecies, EC.EvolutionChain evolutionChain) {

  List<Stat> stats = [];
  pokemonOnly.stats.forEach((e) {
    stats.add(Stat(name: e.stat.name, baseStat: e.baseStat));
  });

  List<String> sprites = [];
  sprites.add(pokemonOnly.sprites.other.home.frontDefault);

  String flavorText = pokemonSpecies.flavorTextEntries.where((element) => element.language.name == "es").toList()[0].flavorText;

  List<Evolution> evolutions = [
    Evolution(
      id: int.parse(evolutionChain.chain.species.url.split('/')[6]),
      name: evolutionChain.chain.species.name,
      evolvesTo: obtainEvolutions(evolutionChain.chain.evolvesTo),
    ),
  ];

  List<String> types = [];
  pokemonOnly.types.forEach((element) {
    types.add(element.type.name);
  });

  List<Move> moves = [];
  pokemonOnly.moves.forEach((element) {
    moves.add(Move(id: int.parse(element.move.url.split("/")[6]), name: element.move.name));
  });

  return PokemonDetails(
    // Pokemon Details
    id: pokemonOnly.id,
    name: pokemonOnly.name,
    types: types,
    height: pokemonOnly.height,
    weight: pokemonOnly.weight,
    stats: stats,
    sprites: sprites,
    moves: moves,

    // PokemonSpecies
    baseHappiness: pokemonSpecies.baseHappiness,
    captureRate: pokemonSpecies.captureRate,
    hatchCounter: pokemonSpecies.hatchCounter,
    generation: pokemonSpecies.generation.name,
    growthRate: pokemonSpecies.growthRate.name,
    flavorText: flavorText,

    // Evolution Chain
    evolutionChain: evolutions,
  );

}

// Funcion para traducir entre clase y DTO
List<Evolution> obtainEvolutions(List<EvolvesTo> evolvesTo){

  List<Evolution> evolutions = [];
  evolvesTo.forEach((e) {
    Evolution evolution = Evolution(
      id: int.parse(e.species.url.split('/')[6]),
      name: e.species.name,
      evolvesTo: obtainEvolutions(e.evolvesTo),
    );
    evolutions.add(evolution);
  });
  return evolutions;

}

class Evolution {
  int id;
  String name;
  List<Evolution> evolvesTo;

  Evolution({
    required this.id,
    required this.name,
    required this.evolvesTo,
  });

}

class Stat{
  String name;
  int baseStat;

  Stat({
    required this.name,
    required this.baseStat,
  });
}

class Move{
  int id;
  String name;

  Move({
    required this.id,
    required this.name,
  });

}
