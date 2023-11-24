import 'dart:async';
import 'dart:ffi';

import 'package:path/path.dart';
import 'package:pokemonfile/DTO/DTO.PokeList.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/Pokemon.dart';

class DatabaseHelper {

  final Future<Database> _database = _initDatabase();

  // Inicializa la base de datos
  static Future<Database> _initDatabase() async {
    Database database = await openDatabase(
    join(await getDatabasesPath(), "pokedex_database.db"),

    onCreate: (db, version) async => _createdb(db),
      version: 1,
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

  // Revisar si un pokemon es favorito o no
  Future<bool> isFavorite(int id) async {
    bool ret = false;

    // Hacer una llamada a la base de datos
    List<Pokemon> pokemon = await pokemonId(id);

    if(pokemon.isNotEmpty){
      ret = pokemon[0].favorite == 1 ? true : false;
    }

    return ret;

  }

  // Cambiar el estado de favorito de un pokemon
  Future<void> changeFavorite(int id) async {

    List<Pokemon> pokemon = await pokemonId(id);
    if(pokemon.isEmpty){
      return;
    }
    if (pokemon[0].favorite == 1){
      pokemon[0].favorite = 0;
      await updatePokemon(pokemon[0]);
    }else{
      pokemon[0].favorite = 1;
      await updatePokemon(pokemon[0]);
    }
  }

  Future<void> insertAllPokemons(PokeList tempPokemons) async {

    final db = await _database;

    List<Pokemon> pokemons = await pokemonList();

    if (pokemons.length == tempPokemons.count){
      return;
    }

    var batch = db.batch();
    tempPokemons.results.forEach((element) async {

      batch.insert(
          'pokemons',
          Pokemon(
            id: int.parse(element.url.split('/')[6]),
            favorite: 0,
            name: element.name,
            type1: "",
            type2: "",
          ).toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace
      );
      //await insertPokemon(Pokemon(id: int.parse(element.url.split('/')[6]), favorite: 0));
    });
    batch.commit();

  }
}