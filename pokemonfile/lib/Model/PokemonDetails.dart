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
  List<Move> moves;
  List<String> sprites;

  // PokemonSpecies
  int captureRate;
  String generation;
  String growthRate;
  int hatchCounter;
  String flavorText;
  List<String> abilities;

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
    required this.moves,
    required this.abilities,
    required this.sprites,

    // PokemonSpecies
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

  // Stats
  List<Stat> stats = [];
  pokemonOnly.stats.forEach((e) {
    stats.add(Stat(name: e.stat.name, baseStat: e.baseStat));
  });

  // Sprites
  List<String> sprites = [];
  if (pokemonOnly.sprites.other.home.frontDefault != null){
    sprites.add(pokemonOnly.sprites.other.home.frontDefault!);
  }
  if (pokemonOnly.sprites.other.officialArtwork.frontDefault != null){
    sprites.add(pokemonOnly.sprites.other.officialArtwork.frontDefault!);
  }
  if (pokemonOnly.sprites.frontDefault != null){
    sprites.add(pokemonOnly.sprites.frontDefault!);
  }
  if(sprites.isEmpty){
    sprites.add('https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemonOnly.id}.png');
  }

  // Flavor Text
  String flavorText = "";
  List<PS.FlavorTextEntries> flavorList = pokemonSpecies.flavorTextEntries.where((element) => element.language.name == "es").toList();
  if (flavorList.isNotEmpty){
    flavorText = flavorList[0].flavorText;
  }

  // Evolutions
  List<Evolution> evolutions = [
    Evolution(
      id: int.parse(evolutionChain.chain.species.url.split('/')[6]),
      name: evolutionChain.chain.species.name,
      evolvesTo: obtainEvolutions(evolutionChain.chain.evolvesTo),
      minLevel: null
    ),
  ];

  // Types
  List<String> types = [];
  pokemonOnly.types.forEach((element) {
    types.add(element.type.name);
  });

  // Moves
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
    moves: moves,
    abilities: pokemonOnly.abilities.map((e) {
      return e.ability.name;
    }).toList(),
    sprites: sprites,

    // PokemonSpecies
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
      minLevel: e.evolutionDetails.isNotEmpty ? e.evolutionDetails[0].minLevel : null,
    );
    evolutions.add(evolution);
  });
  return evolutions;

}

class Evolution {
  int id;
  String name;
  List<Evolution> evolvesTo;
  int? minLevel;

  Evolution({
    required this.id,
    required this.name,
    required this.evolvesTo,
    required this.minLevel,
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

