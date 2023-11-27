import 'dart:convert';

PokemonGraphQL pokemonGraphQLFromJson(String str) => PokemonGraphQL.fromJson(json.decode(str));

String pokemonGraphQLToJson(PokemonGraphQL data) => json.encode(data.toJson());

class PokemonGraphQL {
  List<PokemonV2Pokemon> pokemonList;

  PokemonGraphQL({
    required this.pokemonList
  });

  factory PokemonGraphQL.fromJson(Map<String, dynamic> json) => PokemonGraphQL(
      pokemonList: List<PokemonV2Pokemon>.from(json["pokemon_v2_pokemon"].map((x) => PokemonV2Pokemon.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pokemon_v2_pokemon": List<dynamic>.from(pokemonList.map((x) => x.toJson())),
  };
  
}

class PokemonV2Pokemon {
  int id;
  String name;
  List<PokemonV2PokemonTypes> pokemonV2PokemonTypes;
  List<PokemonV2PokemonSprites> pokemonV2PokemonSprites;

  PokemonV2Pokemon({
    required this.id,
    required this.name,
    required this.pokemonV2PokemonTypes,
    required this.pokemonV2PokemonSprites,
  });

  factory PokemonV2Pokemon.fromJson(Map<String, dynamic> json) =>  PokemonV2Pokemon(
    id: json['id'],
    name: json['name'],
    pokemonV2PokemonTypes: List<PokemonV2PokemonTypes>.from(json["pokemon_v2_pokemontypes"].map((x) => PokemonV2PokemonTypes.fromJson(x))),
    pokemonV2PokemonSprites: List<PokemonV2PokemonSprites>.from(json["pokemon_v2_pokemonsprites"].map((x) => PokemonV2PokemonSprites.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "pokemon_v2_pokemontypes": List<dynamic>.from(pokemonV2PokemonTypes.map((x) => x.toJson())),
  };
}

class PokemonV2PokemonSprites {

  Sprites sprites;

  PokemonV2PokemonSprites({
    required this.sprites
  });

  factory PokemonV2PokemonSprites.fromJson(Map<String, dynamic> data) =>  PokemonV2PokemonSprites(
    sprites: Sprites.fromJson(json.decode(data["sprites"])),
  );

}

class Sprites {

  String? frontDefault;

  Sprites({
    required this.frontDefault,
  });

  factory Sprites.fromJson(Map<String, dynamic> json) =>  Sprites(
    frontDefault: json["front_default"],
  );
}

class PokemonV2PokemonTypes {
  PokemonV2Type pokemonV2Type;

  PokemonV2PokemonTypes({required this.pokemonV2Type});

  factory PokemonV2PokemonTypes.fromJson(Map<String, dynamic> json) => PokemonV2PokemonTypes(
    pokemonV2Type: PokemonV2Type.fromJson(json['pokemon_v2_type']),
  );

  Map<String, dynamic> toJson() => {
    "pokemon_v2_type": pokemonV2Type.toJson(),
  };
}

class PokemonV2Type {
  int id;
  String name;

  PokemonV2Type({
    required this.id,
    required this.name,
  });

  factory PokemonV2Type.fromJson(Map<String, dynamic> json) => PokemonV2Type(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };

}
