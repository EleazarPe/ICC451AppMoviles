import 'package:flutter/material.dart';

class Pokemon {
  int id;
  int favorite;
  String name;
  String type1;
  String type2;


  Pokemon({
    required this.id,
    required this.favorite,
    required this.name,
    required this.type1,
    required this.type2,
  });


  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'favorite': favorite,
      'name': name,
      'type1': type1,
      'type2': type2,
    };
  }

  bool favoriteBool(){
    return favorite == 1 ? true : false;
  }

  Pokemon setPokemonType(List<String> types){

    type1 = "";
    type2 = "";

    if(types.length == 1) {
      type1 = types[0];
    }
    else if (types.length == 2){
      type1 = types[0];
      type2 = types[1];
    }

    return this;
  }

}

Pokemon getPokemonId(List<Pokemon> pokemons, int id){

  Pokemon ret = pokemons[0];
  for (var element in pokemons) {
    if (element.id == id){
      return element;
    }
  }

  return ret;
}

Color getColorForElement(String element) {
  if (element == 'fire') {
    return Colors.red;
  } else if (element == 'water') {
    return Colors.blue;
  } else if (element == 'grass') {
    return Colors.green;
  }else if(element == 'ice'){
    return const Color.fromARGB(255,102,204,255);
  }else if(element == 'fairy'){
    return const Color.fromARGB(255,238,153,238);
  }else if(element == 'electric'){
    return const Color.fromARGB(255,255,204,51);
  }else if(element == 'fighting'){
    return const Color.fromARGB(255,187,85,68);
  }else if(element == 'poison'){
    return const Color.fromARGB(255,146,63,204);
  }else if(element == 'ground'){
    return const Color.fromARGB(255,100,50,25);
  }else if(element == 'flying'){
    return const Color.fromARGB(255,136,153,255);
  }else if(element == 'psychic'){
    return const Color.fromARGB(255,255,85,153);
  }else if(element == 'bug'){
    return const Color.fromARGB(255,170,187,34);
  }else if(element == 'rock'){
    return const Color.fromARGB(255,170,170,153);
  }else if(element == 'ghost'){
    return const Color.fromARGB(255,113,63,113);
  }else if(element == 'dragon'){
    return const Color.fromARGB(255,79,96,226);
  } else if(element == 'dark'){
    return const Color.fromARGB(255,79,63,61);
  } else if(element == 'steel'){
    return const Color.fromARGB(255,96,162,185);
  } else if(element == 'normal'){
    return const Color.fromARGB(255,170,170,153);
  }else{
    return Colors.white;
  }
}

Color textColorForBackground(Color backgroundColor) {
  final luminance = backgroundColor.computeLuminance();
  return luminance > 0.5 ? Colors.black : Colors.white;
}