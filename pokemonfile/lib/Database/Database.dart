import 'dart:async';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:pokemonfile/DTO/DTO.PokemonGraphQL.dart' as PQ;
import 'package:sqflite/sqflite.dart';
import '../Model/Pokemon.dart';

class DatabaseHelper {

  final Future<Database> _database = _initDatabase();

  // Inicializa la base de datos
  static Future<Database> _initDatabase() async {
    Database database = await openDatabase(
    join(await getDatabasesPath(), "pokedex_database.db"),

    onCreate: (db, version) async => _createdb(db),
      version: 2,
    );

    return database;
  }

  // crea la base de datos
  static void _createdb(Database db) async{
    // Create tables
    await db.execute(
      'CREATE TABLE pokemons('
          'id INTEGER PRIMARY KEY, '
          'favorite INTEGER, '
          'name STRING, '
          'type1 STRING, '
          'type2 STRING'
          ')',
    );

    await db.execute(
      'CREATE TABLE hash('
          'id INTEGER PRIMARY KEY, '
          'hash INTEGER '
          ')',
    );

  }

  Future<List<int>> hashList() async {

    final db = await _database;

    final List<Map<String, dynamic>> maps = await db.query('hash');

    return List.generate(maps.length, (i) {
      return maps[i]['hash'] as int;
    });

  }

  Future<void> insertHash(int hash) async {
    final db = await _database;

    Map<String, dynamic> map = {
      'id': 1,
      'hash': hash,
    };

    List<int> list = await hashList();

    if (list.isEmpty){
      await db.insert(
          'hash',
          map,
          conflictAlgorithm: ConflictAlgorithm.replace
      );
    }else{
      await db.update(
        'hash',
        map,
        where: 'id = ?',
        whereArgs: [1],
      );
    }
    print("New Hash has been saved");

  }

  // Insert un pokemon a la vez
  Future<void> insertPokemon(Pokemon pokemon) async {

    final db = await _database;
    
    await db.insert(
        'pokemons',
        pokemon.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
  }


  // Obtener todos los pokemones
  Future<List<Pokemon>> pokemonList() async {
    // Get a reference to the database.
    final db = await _database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('pokemons');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Pokemon(
        id: maps[i]['id'] as int,
        favorite: maps[i]['favorite'] as int,
        name: maps[i]['name'] as String,
        type1: maps[i]['type1'] as String,
        type2: maps[i]['type2'] as String,
        sprites: [],
      );
    });

  }

  // Obtener un solo pokemon usando el id
  Future<List<Pokemon>> pokemonId(int id) async {
    // Get a reference to the database.
    final db = await _database;

    // Query the table for all The Pokemon.
    final List<Map<String, dynamic>> maps = await db.query(
        'pokemons',
      where: 'id = ?',
      whereArgs: [id],
    );

    // Convert the List<Map<String, dynamic> into a List<Pokemon>.
    List<Pokemon> pokemonList = List.generate(maps.length, (i) {
      return Pokemon(
        id: maps[i]['id'] as int,
        favorite: maps[i]['favorite'] as int,
        name: maps[i]['name'] as String,
        type1: maps[i]['type1'] as String,
        type2: maps[i]['type2'] as String,
        sprites: []
      );
    });

    return pokemonList;

  }

  // Update la informacion de un pokemon dado su id
  Future<void> updatePokemon(Pokemon pokemon) async {
    // Get a reference to the database.
    final db = await _database;

    // Update the given Dog.
    await db.update(
      'pokemons',
      pokemon.toMap(),
      where: 'id = ?',
      whereArgs: [pokemon.id],
    );
  }

  // Delete un pokemon
  Future<void> deletePokemon(int id) async {
    // Obtener una referencia de la base de datos.
    final db = await _database;

    // Borrar el pokemon de la base de datos
    await db.delete(
      'pokemons',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Cambiar el estado de favorito de un pokemon
  Future<List<Pokemon>> changeFavorite(int id) async {
    print("Changing Favorite pokemon: $id");
    List<Pokemon> pokemon = await pokemonId(id);
    if(pokemon.isEmpty){
      print("No Pokemon Found");
      return pokemon;
    }
    if (pokemon[0].favorite == 1){
      pokemon[0].favorite = 0;
      await updatePokemon(pokemon[0]);
      print("Success, pokemon unfavorited");
      return pokemon;
    }else {
      pokemon[0].favorite = 1;
      await updatePokemon(pokemon[0]);
      print("Success, pokemon favorited");
      return pokemon;
    }

  }

  Future<List<Pokemon>> updateDatabase(PQ.PokemonGraphQL pokemonGraphQL) async {

    // Ini database
    final db = await _database;

    // get pokemon list and hash from database
    List<Pokemon> dbPokemons = await pokemonList();
    List<int> dbHash = await hashList();

    int newHash = pokemonGraphQL.hashCode;
    print("New hash: $newHash");

    if (dbHash.isNotEmpty){
      print("DB hash:  ${dbHash[0]}");
      if (dbHash[0] == newHash){
        print("No changes to the database, hash hasnt changed.");
        for (var i = 0 ; i < dbPokemons.length ; i ++){
          dbPokemons[i].sprites = _graphQLSpritesToPokemonSprites(pokemonGraphQL.pokemonList[i].pokemonV2PokemonSprites, dbPokemons[i].id);
        }
        return dbPokemons;
      }
    }

    List<Pokemon> pokemons = [];

    pokemonGraphQL.pokemonList.forEach((p) {
      
      String type1 = p.pokemonV2PokemonTypes[0].pokemonV2Type.name;
      String type2 = p.pokemonV2PokemonTypes.length > 1 ? p.pokemonV2PokemonTypes[1].pokemonV2Type.name : "";
      List<String> sprites = _graphQLSpritesToPokemonSprites(p.pokemonV2PokemonSprites, p.id);
      Pokemon poke = Pokemon(
        id: p.id,
        favorite: 0,
        name: p.name,
        type1: type1,
        type2: type2,
        sprites: sprites,
      );
      pokemons.add(poke);
      if (poke.id == 1){
      }
    });

    var batch = db.batch();
    pokemons.forEach((p) {
      batch.insert(
          'pokemons',
          p.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace
      );
    });
    batch.commit().whenComplete(() {
      insertHash(newHash);
    });

    return pokemons;
  }

  List<String> _graphQLSpritesToPokemonSprites(List<PQ.PokemonV2PokemonSprites> pokemonV2PokemonSprites, int id) {

    List<String> sprites = [];

    // Home Front
    if (pokemonV2PokemonSprites[0].sprites.other.home.frontDefault != null){
      sprites.add(pokemonV2PokemonSprites[0].sprites.other.home.frontDefault!);
    }

    // Official Artwork front
    if (pokemonV2PokemonSprites[0].sprites.other.officialArtwork.frontDefault != null){
      sprites.add(pokemonV2PokemonSprites[0].sprites.other.officialArtwork.frontDefault!);
    }

    // Front Default
    if (pokemonV2PokemonSprites[0].sprites.frontDefault != null){
      sprites.add(pokemonV2PokemonSprites[0].sprites.frontDefault!);
    }
    
    if(sprites.isEmpty){
      sprites.add('https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png');
    }

    return sprites;
  }
}