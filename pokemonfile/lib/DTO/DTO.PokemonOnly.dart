import 'dart:convert';

PokemonOnly pokeListFromJson(String str) => PokemonOnly.fromJson(json.decode(str));

String pokeListToJson(PokemonOnly data) => json.encode(data.toJson());

class PokemonOnly {
  List<Ability> abilities;
  int? baseExperience;
  List<Species> forms;
  List<dynamic> gameIndices;
  int height;
  List<HeldItem> heldItems;
  int id;
  bool isDefault;
  String locationAreaEncounters;
  List<Move> moves;
  String name;
  int order;
  List<dynamic> pastAbilities;
  List<dynamic> pastTypes;
  Species species;
  Sprites sprites;
  List<Stat> stats;
  List<Type> types;
  int weight;

  PokemonOnly({
    required this.abilities,
    required this.baseExperience,
    required this.forms,
    required this.gameIndices,
    required this.height,
    required this.heldItems,
    required this.id,
    required this.isDefault,
    required this.locationAreaEncounters,
    required this.moves,
    required this.name,
    required this.order,
    required this.pastAbilities,
    required this.pastTypes,
    required this.species,
    required this.sprites,
    required this.stats,
    required this.types,
    required this.weight,
  });

  factory PokemonOnly.fromJson(Map<String, dynamic> json) => PokemonOnly(
    abilities: List<Ability>.from(json["abilities"].map((x) => Ability.fromJson(x))),
    baseExperience: json["base_experience"],
    forms: List<Species>.from(json["forms"].map((x) => Species.fromJson(x))),
    gameIndices: List<dynamic>.from(json["game_indices"].map((x) => x)),
    height: json["height"],
    heldItems: List<HeldItem>.from(json["held_items"].map((x) => HeldItem.fromJson(x))),
    id: json["id"],
    isDefault: json["is_default"],
    locationAreaEncounters: json["location_area_encounters"],
    moves: List<Move>.from(json["moves"].map((x) => Move.fromJson(x))),
    name: json["name"],
    order: json["order"],
    pastAbilities: List<dynamic>.from(json["past_abilities"].map((x) => x)),
    pastTypes: List<dynamic>.from(json["past_types"].map((x) => x)),
    species: Species.fromJson(json["species"]),
    sprites: Sprites.fromJson(json["sprites"]),
    stats: List<Stat>.from(json["stats"].map((x) => Stat.fromJson(x))),
    types: List<Type>.from(json["types"].map((x) => Type.fromJson(x))),
    weight: json["weight"],
  );

  Map<String, dynamic> toJson() => {
    "abilities": List<dynamic>.from(abilities.map((x) => x.toJson())),
    "base_experience": baseExperience,
    "forms": List<dynamic>.from(forms.map((x) => x.toJson())),
    "game_indices": List<dynamic>.from(gameIndices.map((x) => x)),
    "height": height,
    "held_items": List<dynamic>.from(heldItems.map((x) => x.toJson())),
    "id": id,
    "is_default": isDefault,
    "location_area_encounters": locationAreaEncounters,
    "moves": List<dynamic>.from(moves.map((x) => x.toJson())),
    "name": name,
    "order": order,
    "past_abilities": List<dynamic>.from(pastAbilities.map((x) => x)),
    "past_types": List<dynamic>.from(pastTypes.map((x) => x)),
    "species": species.toJson(),
    "sprites": sprites.toJson(),
    "stats": List<dynamic>.from(stats.map((x) => x.toJson())),
    "types": List<dynamic>.from(types.map((x) => x.toJson())),
    "weight": weight,
  };
}

class Ability {
  Species ability;
  bool isHidden;
  int slot;

  Ability({
    required this.ability,
    required this.isHidden,
    required this.slot,
  });

  factory Ability.fromJson(Map<String, dynamic> json) => Ability(
    ability: Species.fromJson(json["ability"]),
    isHidden: json["is_hidden"],
    slot: json["slot"],
  );

  Map<String, dynamic> toJson() => {
    "ability": ability.toJson(),
    "is_hidden": isHidden,
    "slot": slot,
  };
}

class Species {
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

class HeldItem {
  Species item;
  List<VersionDetail> versionDetails;

  HeldItem({
    required this.item,
    required this.versionDetails,
  });

  factory HeldItem.fromJson(Map<String, dynamic> json) => HeldItem(
    item: Species.fromJson(json["item"]),
    versionDetails: List<VersionDetail>.from(json["version_details"].map((x) => VersionDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "item": item.toJson(),
    "version_details": List<dynamic>.from(versionDetails.map((x) => x.toJson())),
  };
}

class VersionDetail {
  int rarity;
  Species version;

  VersionDetail({
    required this.rarity,
    required this.version,
  });

  factory VersionDetail.fromJson(Map<String, dynamic> json) => VersionDetail(
    rarity: json["rarity"],
    version: Species.fromJson(json["version"]),
  );

  Map<String, dynamic> toJson() => {
    "rarity": rarity,
    "version": version.toJson(),
  };
}

class Move {
  Species move;
  List<VersionGroupDetail> versionGroupDetails;

  Move({
    required this.move,
    required this.versionGroupDetails,
  });

  factory Move.fromJson(Map<String, dynamic> json) => Move(
    move: Species.fromJson(json["move"]),
    versionGroupDetails: List<VersionGroupDetail>.from(json["version_group_details"].map((x) => VersionGroupDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "move": move.toJson(),
    "version_group_details": List<dynamic>.from(versionGroupDetails.map((x) => x.toJson())),
  };
}

class VersionGroupDetail {
  int levelLearnedAt;
  Species moveLearnMethod;
  Species versionGroup;

  VersionGroupDetail({
    required this.levelLearnedAt,
    required this.moveLearnMethod,
    required this.versionGroup,
  });

  factory VersionGroupDetail.fromJson(Map<String, dynamic> json) => VersionGroupDetail(
    levelLearnedAt: json["level_learned_at"],
    moveLearnMethod: Species.fromJson(json["move_learn_method"]),
    versionGroup: Species.fromJson(json["version_group"]),
  );

  Map<String, dynamic> toJson() => {
    "level_learned_at": levelLearnedAt,
    "move_learn_method": moveLearnMethod.toJson(),
    "version_group": versionGroup.toJson(),
  };
}

class Sprites {
  Other other;

  Sprites({
    required this.other,
  });

  factory Sprites.fromJson(Map<String, dynamic> json) => Sprites(
    other: Other.fromJson(json["other"]),
  );

  Map<String, dynamic> toJson() => {
    "other": other.toJson(),
  };
}

class Other {
  Home home;

  Other({
    required this.home,
  });

  factory Other.fromJson(Map<String, dynamic> json) => Other(
    home: Home.fromJson(json["home"]),
  );

  Map<String, dynamic> toJson() => {
    "home": home.toJson(),
  };
}

class Home {
  String? frontDefault;

  Home({
    required this.frontDefault,
  });

  factory Home.fromJson(Map<String, dynamic> json) => Home(
    frontDefault: json["front_default"],
  );

  Map<String, dynamic> toJson() => {
    "front_default": frontDefault,
  };
}

class Stat {
  int baseStat;
  int effort;
  Species stat;

  Stat({
    required this.baseStat,
    required this.effort,
    required this.stat,
  });

  factory Stat.fromJson(Map<String, dynamic> json) => Stat(
    baseStat: json["base_stat"],
    effort: json["effort"],
    stat: Species.fromJson(json["stat"]),
  );

  Map<String, dynamic> toJson() => {
    "base_stat": baseStat,
    "effort": effort,
    "stat": stat.toJson(),
  };
}

class Type {
  int slot;
  Species type;

  Type({
    required this.slot,
    required this.type,
  });

  factory Type.fromJson(Map<String, dynamic> json) => Type(
    slot: json["slot"],
    type: Species.fromJson(json["type"]),
  );

  Map<String, dynamic> toJson() => {
    "slot": slot,
    "type": type.toJson(),
  };
}
