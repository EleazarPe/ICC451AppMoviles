### pokemonfile

## Proyecto POKEDEX Segundo Parcial

## Base de Datos
La base de datos esta basada en SQLite. Tenemos una clase Pokemon que tiene los tipos:
-	id, int primary key
-	favorite, int
-	name, String
-	
## Integracion de API
Nuestra principal fuente de informacion para obtener nombre y id de los pokemones proviene de: "https://pokeapi.co/api/v2/pokemon/". Para la cual recurrimos a utilizar un DTO llamado PokeList.dart donde luego de realizar una consulta http el resultado lo instanciamos.
Segunda fuente de informacion para los detalles e informacion de pokemones proviene de:
"https://pokeapi.co/api/v2/pokemon/1/" donde utilizamos el DTO llamado PokeOnly.dart.

## Clase DatabaseHelper
Podemos acceder la base de datos usando la clase DatabaseHelper
# Funciones:
  Future<void> insertPokemon(Pokemon)
	Insertar un pokemon a la base de datos.
Future<void> insertAllPokemons(PokeList) 
	Insertar varios pokemones a la base de datos.
Future<List<Pokemon>> pokemonList()
	Listar todos los pokemones.
Future<List<Pokemon>> pokemonId(int id)
	Retorna una lista con solo 1 pokemon.
Future<void> updatePokemon(Pokemon pokemon)
	Actualizar un pokemon.
Future<void> deletePokemon(int id)
	Borra un pokemon.
Future<bool> isFavorite(int id)
	Retorna si un pokemon es favorito o no.
Future<void> changeFavorite(int id)
	Cambia el estado de favorito de un pokemon.

## Clase Pokemon
Clase que se usa para obtener información de la base de datos
# Variables:
-	  int id;
-	  int favorite;
-	  String name;
# Funciones:
bool favoriteBool()
	Función para transformar la variable favorite en boolean.
getPokemonId(List<Pokemon> pokemons, int id)
	Obtener el pokemon dado una lista de pokemones.
Color getColorForElement(String element)
	Dado un tipo de pokemon, obtener un color.
textColorForBackground(Color backgroundColor)
	Dado la iluminación de un color, obtener el color negro o blanco.

## Widget
# PokemonCard
Esta clase tiene un stateful widget tipo card que usamos para la lista. Este recibe la información básica del pokemon para renderizarla. También integramos la instancia de la base de datos para cambiar el estado de favorito del pokemon. 

## Funciones para la consulta a la API(PokemonListPage):
Cargamos 50 pokemones al iniciar la aplicacion de fetchPokemons()
Capturamos la informacion de los pokemones para realizar la busqueda por Id y Nombre allPokemons()
Si a nuestras peticiones le agregamos el siguiente QueryParam "?limit=50&offset=" nos permite cargar 50 pokemones
a partir de el offset en el cual nos encontramos fetchMorePokemons()

