import 'dart:convert';

PokemonSpecies pokeListFromJson(String str) => PokemonSpecies.fromJson(json.decode(str));
String pokeListToJson(PokemonSpecies data) => json.encode(data.toJson());


class PokemonSpecies {

  int baseHappiness;
  int captureRate;
  EvolutionChain evolutionChain;
  List<FlavorTextEntries> flavorTextEntries;
  Generation generation;
  GrowthRate growthRate;
  int hatchCounter;

  PokemonSpecies({
    required this.baseHappiness,
    required this.captureRate,
    required this.evolutionChain,
    required this.flavorTextEntries,
    required this.generation,
    required this.growthRate,
    required this.hatchCounter,
  });

  factory PokemonSpecies.fromJson(Map<String, dynamic> json) => PokemonSpecies(

    baseHappiness: json["base_happiness"],
    captureRate: json["capture_rate"], 
    evolutionChain: EvolutionChain.fromJson(json["evolution_chain"]),
    flavorTextEntries: List<FlavorTextEntries>.from(json["flavor_text_entries"].map((x) => FlavorTextEntries.fromJson(x))),
    generation: Generation.fromJson(json["generation"]),
    growthRate: GrowthRate.fromJson(json["growth_rate"]),
    hatchCounter: json["hatch_counter"],


  );

  Map<String, dynamic> toJson() => {

    "base_happiness": baseHappiness,
    "capture_rate": captureRate,
    "evolution_chain": evolutionChain.toJson(),
    "flavor_text_entries": List<dynamic>.from(flavorTextEntries.map((x) => x.toJson())),
    "generation": generation.toJson(),
    "growth_rate": growthRate.toJson(),
    "hatch_counter": hatchCounter,

  };

}




// DONE
class GrowthRate {

  String name;
  String url;

  GrowthRate({
    required this.name,
    required this.url,
  });

  factory GrowthRate.fromJson(Map<String, dynamic> json) => GrowthRate(
    name: json["name"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "url": url,
  };

}

// DONE
class Generation {

  String name;
  String url;

  Generation({
    required this.name,
    required this.url,
  });

  factory Generation.fromJson(Map<String, dynamic> json) => Generation(
    name: json["name"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "url": url,
  };
  
}

// DONE
class EvolutionChain {
  String url;

  EvolutionChain({
    required this.url
  });

  factory EvolutionChain.fromJson(Map<String, dynamic> json) => EvolutionChain(
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
  };

}

// DONE
class FlavorTextEntries {

  String flavorText;
  Language language;
  Version version;

  FlavorTextEntries({
    required this.flavorText,
    required this.language,
    required this.version,
  });

  factory FlavorTextEntries.fromJson(Map<String, dynamic> json) => FlavorTextEntries(
    flavorText: json["flavor_text"],
    language: Language.fromJson(json["language"]),
    version: Version.fromJson(json["version"]),
  );

  Map<String, dynamic> toJson() => {
    "flavor_text": flavorText,
    "language": language.toJson(),
    "version": version.toJson()
  };

}

// DONE
class Language {
  String name;
  String url;

  Language({
    required this.name,
    required this.url,
  });

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    name: json["name"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "url": url,
  };

}

// DONE
class Version {
  String name;
  String url;

  Version({
    required this.name,
    required this.url,
  });

  factory Version.fromJson(Map<String, dynamic> json) => Version(
    name: json["name"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "url": url,
  };
}






