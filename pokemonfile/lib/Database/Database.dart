import 'dart:async';
import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/Pokemon.dart';

class DatabaseHelper {

  final Future<Database> _database = _initDatabase();

  static Future<Database> _initDatabase() async {
    Database database = await openDatabase(
    join(await getDatabasesPath(), "pokedex_database.db"),

    onCreate: (db, version) async => _createdb(db),
      version: 1,
    );

    return database;
  }

  static void _createdb(Database db) async{
    // Create tables
    await db.execute(
      'CREATE TABLE pokemons('
          'id INTEGER PRIMARY KEY, '
          'name TEXT,'
          'favorite BOOLEAN'
          ')',
    );

    //TODO: No es la mejor implementacion para los favoritos, para un futuro es mejor tener la tabla de los favoritos separada de los pokemones.
    // Create tables
    /*await db.execute(
      'CREATE TABLE favorites('
          'id INTEGER PRIMARY KEY, '
          'favorite BOOLEAN'
          ')',
    );*/

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
  Future<List<Pokemon>> pokemons() async {
    // Get a reference to the database.
    final db = await _database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('pokemons');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Pokemon(
        id: maps[i]['id'] as int,
      );
    });

  }

  // Update la informacion de un pokemon dado su id
  Future<void> updatePokemon(Pokemon pokemon) async {
    // Get a reference to the database.
    final db = await _database;

    // Update the given Dog.
    await db.update(
      'pokemons',
      pokemon.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [pokemon.id],
    );
  }

  // Delete un pokemon
  Future<void> deletePokemon(int id) async {
    // Get a reference to the database.
    final db = await _database;

    // Remove the Dog from the database.
    await db.delete(
      'pokemons',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<bool> isFavorite(int id) async {

    bool ret = false;

    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      'pokemons',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (!maps.isEmpty){
      ret = true;
    }
    return ret;

  }

  Future<void> changeFavorite(int id) async {

    if (await isFavorite(id)){
      deletePokemon(id);
    }else{
      insertPokemon(Pokemon(id: id));
    }

  }



}