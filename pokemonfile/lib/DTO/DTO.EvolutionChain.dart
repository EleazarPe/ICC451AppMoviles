import 'dart:convert';

EvolutionChain pokeListFromJson(String str) => EvolutionChain.fromJson(json.decode(str));
String pokeListToJson(EvolutionChain data) => json.encode(data.toJson());

// Done
class EvolutionChain{

  Chain chain;

  EvolutionChain({
    required this.chain,
  });

  factory EvolutionChain.fromJson(Map<String, dynamic> json) => EvolutionChain(
      chain: Chain.fromJson(json["chain"]),
  );

  Map<String, dynamic> toJson() => {
    "chain": chain.toJson(),
  };


}

// Done
class Chain {

  List<EvolvesTo> evolvesTo;
  Species species;

  Chain({
    required this.evolvesTo,
    required this.species,
  });

  factory Chain.fromJson(Map<String, dynamic> json) => Chain(
    species: Species.fromJson(json["species"]),
    evolvesTo: List<EvolvesTo>.from(json["evolves_to"].map((x) => EvolvesTo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "species": species.toJson(),
    "evolves_to": List<dynamic>.from(evolvesTo.map((x) => x.toJson())),
  };

}

// Done
class EvolvesTo {

  Species species;
  List<EvolvesTo> evolvesTo;

  EvolvesTo({
    required this.species,
    required this.evolvesTo,
  });

  factory EvolvesTo.fromJson(Map<String, dynamic> json) => EvolvesTo(
    species: Species.fromJson(json["species"]),
    evolvesTo: List<EvolvesTo>.from(json["evolves_to"].map((x) => EvolvesTo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "species": species.toJson(),
    "evolves_to": List<dynamic>.from(evolvesTo.map((x) => x.toJson())),
  };

}

// Done
class Species{
  String name;
  String url;

  Species({
    required this.name,
    required this.url,
  });

  factory Species.fromJson(Map<String, dynamic> json) => Species(
    name: json["name"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "url": url,
  };

}