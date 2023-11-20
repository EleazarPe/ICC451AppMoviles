import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
//import 'package:path/path.dart';
import '../DTO/PokeList.dart';
import '../Database/Database.dart';
import '../DTO/PokeOnly.dart';
import '../Model/Pokemon.dart';
import '../Widgets/PokemonCard.dart' as pc;

class PokemonDetailsPage extends StatefulWidget {
  final Pokemon pokemonDB;

  PokemonDetailsPage({required this.pokemonDB});

  @override
  _PokemonDetailsPageState createState() => _PokemonDetailsPageState(pokemonDB: pokemonDB);
}

class _PokemonDetailsPageState extends State<PokemonDetailsPage> {

  _PokemonDetailsPageState({required this.pokemonDB});

  DatabaseHelper db = DatabaseHelper();
  late final Pokemon pokemonDB;
  late PokeOnly pokemonDetails;
  late bool loading = true;

  static const double _statsVerticalLength = 12.0;
  
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    loadPokemonDetails();
    updatePokemonDB();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: appBarDefault(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
              height: 200, // Ajusta el tamaño según la imagen del Pokémon
              child: Stack(

                children: [

                  // Imagen de Pokeball en el BG
                  Container(

                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5.0),
                    child: const Image(
                      image: AssetImage('assets/icons/pokeballBG.png'),
                      opacity: AlwaysStoppedAnimation(.8),
                    ),
                  ),

                  // Imagen del pokemon
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5.0),
                    child: Image.network(
                      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${pokemonDB.id}.png',
                    ),
                  ),

                ],
              )


            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  _buildNavigationItem(0, 'Información'),
                  _buildNavigationItem(1, 'Estadísticas'),
                  _buildNavigationItem(2, 'Evoluciones'),
                  _buildNavigationItem(3, 'Movimientos'),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildSectionInformacion(),
                  _buildSectionEstadisticas(),
                  _buildSection('Evoluciones'),
                  _buildSectionMovimientos(),
                ],
              ),
            ),
          ],
        ),
      );
  }

  Widget _buildNavigationItem(int index, String title) {

    Widget tabIcon =
    Text(
      title,
      style: const TextStyle(fontSize: 16),
    );
    switch(index){
      case 0:{
        tabIcon = Container(
          alignment: Alignment.center,
          child: const Image(
            image: AssetImage('assets/icons/Info.png'),
          ),
        );
      }
      break;

      case 1:{
        tabIcon = Container(
          alignment: Alignment.center,
          child: const Image(
            image: AssetImage('assets/icons/stats.png'),
          ),
        );
      }
      break;

      case 2:{
        tabIcon = Container(
          alignment: Alignment.center,
          child: const Image(
            image: AssetImage('assets/icons/evolution.png'),
          ),
        );
      }
      break;

      case 3:{
        tabIcon = Container(
          alignment: Alignment.center,
          child: const Image(
            image: AssetImage('assets/icons/tm.png'),
          ),
        );
      }
      break;
    }

    return TextButton(
      onPressed: () {
        setState(() {
          _currentPage = index;
          _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.ease);
        });
      },
      style: TextButton.styleFrom(primary: _currentPage == index ? Colors.blue : Colors.grey),
      child: Container(
        height: 25,
        alignment: Alignment.center,
        child: tabIcon,
      ),
    );
  }

  // Tab de Informacion
  Widget _buildSectionInformacion() {
    return loading ?
    ListView() :

    ListView(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0),

      children: [

        // Padding los tipos del pokemon
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: Row(

            children: [

              // Const String Tipo
              const Expanded(
                flex: 1,
                child: Text(
                  'Tipo',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Los boxes con los tipos de pokemon
              Expanded(
                flex: 2,
                child: Row(
                  children: pokemonDetails.types.map((element) {
                    Color color = getColorForElement(element.type.name);
                    Color textColor = textColorForBackground(color);
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 3.0, right: 3.0, top: 5.0),
                        padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          element.type.name,
                          style: TextStyle(color: textColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList() ?? [],
                ),
              ),
            ],
          ),
        ),


        // Padding para las caracteristicas del pokemon
        Padding(
          padding:const EdgeInsets.symmetric(vertical: 3.0),
          child: Column(
            children: [

              // Texto de Caracteristicas
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 10),
                child: const Text(
                  'Caracteristicas',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Informacion de la Altura
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  // Contenedor con la imagen de Altura
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    child: const Image(
                      image: AssetImage('assets/icons/measuring.png'),
                      height: 32.0,
                    ),
                  ),

                  // Texto constante "Altura"
                  const Text(
                    'Altura',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Informacion de la Altura
                  Expanded(
                      child: Container(

                        margin: const EdgeInsets.only(right: 5.0),
                        alignment: Alignment.centerRight,

                        child: Text(
                          pokemonDetails.height.toString(),
                          style: const TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ),
                  ),

                ],
              ),

              // Informacion del Peso
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  // Contenedor con la imagen de Altura
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    child: const Image(
                      image: AssetImage('assets/icons/weight.png'),
                      height: 32.0,
                    ),
                  ),

                  // Texto constante "Altura"
                  const Text(
                    'Peso',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Informacion de la Altura
                  Expanded(
                    child: Container(

                      margin: const EdgeInsets.only(right: 5.0),
                      alignment: Alignment.centerRight,

                      child: Text(
                        pokemonDetails.weight.toString(),
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),

                ],
              ),


            ],
          ),
        ),
      ],

    );
  }

  // Tab de Estadisticas
  Widget _buildSectionEstadisticas() {
    return loading ?
    ListView() :
    ListView(

      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0),

      children: [

        // Padding para String "Estadisticas"
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 3.0),

          // Const String "Stats"
          child : Text(
              'Estadisticas',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        // HP
        Container(
            padding: const EdgeInsets.symmetric(vertical: _statsVerticalLength),
          //padding: const EdgeInsets.symmetric(vertical: 5.0),

          child:

          Row(
            children: [

              // String HP
              const Expanded(
                flex: 2,
                child: Text(
                  'HP',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Dato HP
              Expanded(
                flex: 1,
                child: Text(
                  pokemonDetails.stats[0].baseStat.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Barra de HP
              Expanded(
                flex: 4,
                child: Container(
                  height: 20,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: LinearProgressIndicator(
                      value: pokemonDetails.stats[0].baseStat/255,
                      valueColor: AlwaysStoppedAnimation<Color>(getColorForElement(pokemonDetails.types[0].type.name)),
                      backgroundColor: const Color(0xffD6D6D6),
                    ),
                  ),
                ),
              ),

            ],
          )
        ),

        // Attack
        Container(
            padding: const EdgeInsets.symmetric(vertical: _statsVerticalLength),

            child:

            Row(
              children: [

                // String Attack
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Attack',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Dato Attack
                Expanded(
                  flex: 1,
                  child: Text(
                    pokemonDetails.stats[1].baseStat.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Barra de Attack
                Expanded(
                  flex: 4,
                  child: Container(
                    height: 20,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: LinearProgressIndicator(
                        value: pokemonDetails.stats[1].baseStat/255,
                        valueColor: AlwaysStoppedAnimation<Color>(getColorForElement(pokemonDetails.types[0].type.name)),
                        backgroundColor: const Color(0xffD6D6D6),
                      ),
                    ),
                  ),
                ),

              ],
            )
        ),

        // Defense
        Container(
            padding: const EdgeInsets.symmetric(vertical: _statsVerticalLength),

            child:

            Row(
              children: [

                // String Defense
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Defense',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Dato Defense
                Expanded(
                  flex: 1,
                  child: Text(
                    pokemonDetails.stats[2].baseStat.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Barra de Defense
                Expanded(
                  flex: 4,
                  child: Container(
                    height: 20,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: LinearProgressIndicator(
                        value: pokemonDetails.stats[2].baseStat/255,
                        valueColor: AlwaysStoppedAnimation<Color>(getColorForElement(pokemonDetails.types[0].type.name)),
                        backgroundColor: const Color(0xffD6D6D6),
                      ),
                    ),
                  ),
                ),

              ],
            )
        ),

        // Special-Attack
        Container(
            padding: const EdgeInsets.symmetric(vertical: _statsVerticalLength),

            child:

            Row(
              children: [

                // String Special-Attack
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Special Attack',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Dato Special-Attack
                Expanded(
                  flex: 1,
                  child: Text(
                    pokemonDetails.stats[3].baseStat.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Barra de Special-Attack
                Expanded(
                  flex: 4,
                  child: Container(
                    height: 20,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: LinearProgressIndicator(
                        value: pokemonDetails.stats[3].baseStat/255,
                        valueColor: AlwaysStoppedAnimation<Color>(getColorForElement(pokemonDetails.types[0].type.name)),
                        backgroundColor: const Color(0xffD6D6D6),
                      ),
                    ),
                  ),
                ),

              ],
            )
        ),

        // Special-Defense
        Container(
            padding: const EdgeInsets.symmetric(vertical: _statsVerticalLength),

            child:

            Row(
              children: [

                // String Special Defense
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Special Defense',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Dato Special-Attack
                Expanded(
                  flex: 1,
                  child: Text(
                    pokemonDetails.stats[4].baseStat.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Barra de Special-Attack
                Expanded(
                  flex: 4,
                  child: Container(
                    height: 20,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: LinearProgressIndicator(
                        value: pokemonDetails.stats[4].baseStat/255,
                        valueColor: AlwaysStoppedAnimation<Color>(getColorForElement(pokemonDetails.types[0].type.name)),
                        backgroundColor: const Color(0xffD6D6D6),
                      ),
                    ),
                  ),
                ),

              ],
            )
        ),

        // Special-Defense
        Container(
            padding: const EdgeInsets.symmetric(vertical: _statsVerticalLength),

            child:

            Row(
              children: [

                // String Special Defense
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Speed',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Dato Special-Attack
                Expanded(
                  flex: 1,
                  child: Text(
                    pokemonDetails.stats[5].baseStat.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Barra de Special-Attack
                Expanded(
                  flex: 4,
                  child: Container(
                    height: 20,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: LinearProgressIndicator(
                        value: pokemonDetails.stats[5].baseStat/255,
                        valueColor: AlwaysStoppedAnimation<Color>(getColorForElement(pokemonDetails.types[0].type.name)),
                        backgroundColor: const Color(0xffD6D6D6),
                      ),
                    ),
                  ),
                ),

              ],
            )
        ),

      ]
    );
  }

  Widget _buildSectionMovimientos() {
    return loading ?
    ListView() : ListView();

  }

  Widget _buildSection(String sectionName) {
    return loading ?
    ListView() :

    ListView(
      padding: const EdgeInsets.all(5.0),

      children: const [

        Text(
          'Tipo:',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),

        Column(
          children: [

          ],
        ),


      ],

    );
  }



  // AppBar para la pagina de detalles
  AppBar appBarDefault(){
    return AppBar(
        title: Text(pokemonDB.name),
        //backgroundColor: Color.fromARGB(255, 202, 0, 16),
        backgroundColor: loading ? const Color.fromARGB(255, 202, 0, 16) : getColorForElement(pokemonDetails.types[0].type.name),

        actions: [
          Container(
            alignment: Alignment.centerRight,
            child: Text('${pokemonDB.id}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24),
            ),
          ),

          // Favorite Icon
          IconButton(
            icon: pokemonDB.favoriteBool() ?
            const Icon(Icons.favorite_outlined, color: Colors.red,) :
            const Icon(Icons.favorite_border_outlined) ,
            onPressed: () async {
              await db.changeFavorite(pokemonDB.id);
              updatePokemonDB();

              },
          ),


        ]
    );
  }

  // Cargar los detalles del pokemon
  void loadPokemonDetails() async {
    http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/${pokemonDB.id}/')).then((response) {

      if (response.statusCode == 200){
        final data = json.decode(response.body);
        pokemonDetails = PokeOnly.fromJson(data);

        setState(() {
          loading = false;
        });

      }else{
        throw Exception('Failed to load details for pokemon ${pokemonDB.id}');
      }

    });
    
  }

  Future<void> updatePokemonDB() async {

    List<Pokemon> list = await db.pokemonId(pokemonDB.id);
    pokemonDB = list[0];
    setState(() {});

  }

}