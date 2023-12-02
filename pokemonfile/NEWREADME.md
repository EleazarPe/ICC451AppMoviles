# Pokedex - Proyecto Final
## Por: Migual Noboa y Carlos Peterson

# Contenidos
## - [Objetivo de la Aplicacion](#objetivo-del-proyecto)
## - [Necesidades de la Aplicacion](#necesidades-de-la-aplicacion)
## - [Partes Opcionales Agregadas a la Aplicacion](#partes-opcionales-agregadas-a-la-aplicacion)
## - [Documentacion](#documentacion)

# Objetivo del Proyecto
#### [Regresar a Contenidos](#contenidos)
El gran objetivo de este proyecto es mostrar practicamente todo lo que se ha aprendido durante la clase de aplicaciones moviles. Esta aplicacion muestra una acumulacion de todas las tecnologias aprendidas durante el semestres al igual que nuestras habilidades de creatividad e investigacion en forma practica.

Este proyecto contiene todas las necesidades dadas por el documento al igual que varias tecnologias y funcionalidades opcionales, las cuales  

# Necesidades de la Aplicacion
#### [Regresar a Contenidos](#contenidos)

### Interfaz de Usuario
- Una lista de Pokémon con sus nombres e imágenes.
- Una función de búsqueda que permita a los usuarios buscar Pokémon por nombre o número.
- Una vista de detalles de Pokémon que muestre información detallada, como tipo, estadísticas, habilidades, evoluciones, movimientos, etc.
- Posibilidad de marcar Pokémon como favoritos.

Hemos creado una interface que creamos ser bastante accesible y comoda para los usuarios. Debido la forma de carga que escogimos la aplicacion carga bastante rapido y es super fluida, donde lo unico que podria tomar mucho siendo la carga de las imagenes de cada pokemon. 
En la pagina de detalles hemos podido enseñar todas las informaciones que se ha pedido y de una manera comoda y legible. 
En la pagina principal podemos buscar por nombres de pokemones, id de un pokemon especifico y poner un filtro de busqueda de pokemones favoritos.
Y va sin decir pero hemos podido implementar correctamente una base de datos que contiene la informaion basica del pokemon, pero mas importante contiene la informacion si es un pokemon favorito o no.

### Integración de la API

Hemos usado dos herramientas para comunicarnos con la api. Primero es usando el api rest, este contiene varios endpoints los cuales usamod para obtener los detalles de los pokemones. En especifico usamos los endpoints para el pokemon species y evolution chain. La otra herramienta es GraphQL, esta la usamos para buscar la lista completa de pokemones y agregarles los tipos a cada uno. La razon por la cual no implementamos GraphQL para todo es porque es bastante limitada. Ya que no podemos encontrar el evolution chain en GraphQL decidimos hacer las llamadas normales.

### Navegacion y Personalizacion

La navegacion es bastante intuitiva, si quieres filtrar por favoritos le das al corazon, precionando en la lista te manda al pokemon y dandole a las evoluciones del pokemon te da los detalles del mismo. En general hemos podido incorporar una ui intuitiva bastante bien. Y miesntras que es verdad que tomamos inspiracion de otras aplicaciones, sentimos que nuestro estilo es unico y viene de nosotros.

Esta es una adicion opcional, pero hemos implementado SQLite al programa, la cual nos deja guardar no solo el estado de favorito del pokemon, pero tambien el id, nombre, y tipos.


#### Siguiente tema: [Partes Opcionales Agregadas a la Aplicacion](#partes-opcionales-agregadas-a-la-aplicacion)
#### [Regresar a Contenidos](#contenidos)

### Imagenes
![image](https://github.com/EleazarPe/ICC451AppMoviles/assets/132306836/dab16c8b-5e6f-4804-90ad-0a474906fe6a)
![image](https://github.com/EleazarPe/ICC451AppMoviles/assets/132306836/7ed770ab-9361-47db-ad2d-e4f4820cd66d)
![image](https://github.com/EleazarPe/ICC451AppMoviles/assets/132306836/f812f17f-1486-403a-96f3-ff7cd6fbb759)
![image](https://github.com/EleazarPe/ICC451AppMoviles/assets/132306836/e03c9b3b-0529-4da0-b321-c56472aa434d)
![image](https://github.com/EleazarPe/ICC451AppMoviles/assets/132306836/ace0650f-608f-4bee-ad1e-16af84b1363a)
![image](https://github.com/EleazarPe/ICC451AppMoviles/assets/132306836/dad55bd5-9513-4296-91f6-659fab01bc3e)
![image](https://github.com/EleazarPe/ICC451AppMoviles/assets/132306836/102b4f39-ed16-40f3-ae38-5e142c786138)

# Partes Opcionales Agregadas a la Aplicacion
#### [Regresar a Contenidos](#contenidos)

### Implementación de un Sistema de Filtrado y Ordenación de Pokémon

Es posible filtrar por pokemones favoritos.

### Animaciones y Transiciones Para Mejorar la Experiencia del Usuario

Hemos agregado varias animaciones en la aplicacion para que los usuarios se sientan que el programa esta corriendo y funcionando, ayudando a la responsividad de la aplicacion

![image](https://github.com/EleazarPe/ICC451AppMoviles/assets/132306836/3bff62d0-ffb2-4469-a7e8-25a0ee5d7998)
![image](https://github.com/EleazarPe/ICC451AppMoviles/assets/132306836/8b2fa293-8d26-4221-b8b1-de1822d32045)

# Documentacion
#### [Regresar a Contenidos](#contenidos)

- [Estructura del Proyecto](#estructura-del-proyecto)

### Estructura del Proyecto

Los folders y documentos estan organizados en manera de arbol, se hace facil ver a simple ver como esta compuesto el proyecto

![image](https://github.com/EleazarPe/ICC451AppMoviles/assets/132306836/b96187ea-5ec8-4652-8648-f76b2f730ac0)

### Base de Datos y como accesarlas

La base de datos esta basada en SQLite, esta contiene una tabla "pokemons".

La tabla pokemons tiene 5 datos:
- id INTEGER PRIMARY KEY; id del pokemon.
- favorite INTEGER; 1 si el pokemon es una favorito 0 si no lo es.
- name STRING; nombre del pokemon.
- type1 STRING; primer tipo del pokemon.
- tepy2 STRING; segundo tipo del pokemon, estara como "" si no tiene.

La base de datos se puede accesar con el database Helper. Aparte de las funciones del CRUD normal tenemos algunas diferentes.
- Future<List<Pokemon>> pokemonId(int id); obtiene el pokemon con el id especifico y retorna una lista con ese pokemon, si esta vacia es que no se encontro el pokemon.
- Future<List<Pokemon>> changeFavorite(int id); cambia es el estado de favorito de el pokemon con un id en especifico.
- Future<List<Pokemon>> updateDatabase(PQ.PokemonGraphQL pokemonGraphQL); Toma el Json proveniente de graphQL con la lista de los pokemons y actualiza la base de datos, tambien agrega los sprites a la lista en memoria de los pokemones. Es llamada al principio de la apliacacion.


