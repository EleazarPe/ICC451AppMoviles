import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokemonfile/Pages/DetailsPage/Tabs/Estadisticas/Details.Tab.Estadisticas.dart';
import 'package:pokemonfile/Pages/DetailsPage/Tabs/Evoluciones/Details.Tab.Evoluciones.dart';
import 'package:pokemonfile/Pages/DetailsPage/Tabs/Informacion/Details.Tab.Informacion.dart';
import 'package:pokemonfile/Pages/DetailsPage/Tabs/Movimientos/Details.Tab.Movimientos.dart';
import '../../DTO/DTO.EvolutionChain.dart' as EC;
import '../../DTO/DTO.PokemonOnly.dart' as PO;
import '../../DTO/DTO.PokemonSpecies.dart' as PS;
import '../../Database/Database.dart';
import '../../Model/Pokemon.dart';
import '../../Model/PokemonDetails.dart';

typedef PokemonCallBack = void Function(int id, int favorite);

class PokemonDetailsPage extends StatefulWidget {

  final PokemonCallBack onSonChanged;
  final int id;

  PokemonDetailsPage({
    required this.onSonChanged,
    required this.id,
  });

  @override
  _PokemonDetailsPageState createState() =>
      _PokemonDetailsPageState(
        pokemonId: id,
        onSonChanged: onSonChanged,
      );
}

class _PokemonDetailsPageState extends State<PokemonDetailsPage> {
  _PokemonDetailsPageState({
    required this.pokemonId,
    required this.onSonChanged,
  });

  final int pokemonId;
  final PokemonCallBack onSonChanged;
  DatabaseHelper db = DatabaseHelper();
  //late Pokemon pokemonDB;
  late PokemonDetails pokemonDetails;
  late bool loading = true;
  late bool loadingError = false;
  bool favorite = false;

  List<String> sprites = [];

  static const double _statsVerticalLength = 12.0;

  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    loadPokemonDetails();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return loading ?
        // TODO: ADD A LOADING BIT HERE TO MAKE IT MORE SEEMLESS
    Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center (
              child: Image(
                image: AssetImage("assets/gif/pikachu-running.gif"),
                height: 75,
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(10.0),
              child: const Text("Loading..."),
            ),
          ],
        ),
      ),
    ) :

    Scaffold(
      appBar: DetailsAppBar(),
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
                    child: pokemonDetails.sprites.isNotEmpty ?
                    CachedNetworkImage(
                      imageUrl: pokemonDetails.sprites[0],
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red))),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ) :
                    const Icon(Icons.error)
                  ),
                ],
              )),
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
                _buildSectionEvoluciones(),
                _buildSectionMovimientos(),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // TabIcons
  Widget _buildNavigationItem(int index, String title) {
    String asset = "placeholder";
    switch (index) {
      case 0:
      {
        asset = 'assets/icons/Info.png';
      }
      break;

      case 1:
      {
        asset = 'assets/icons/stats.png';
      }
      break;

      case 2:
      {
        asset = 'assets/icons/evolution.png';
      }
      break;

      case 3:
      {
        asset = 'assets/icons/tm.png';
      }
      break;
    }

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3.0),
        child: TextButton(
          style: ButtonStyle(
            side: MaterialStateProperty.all(
                BorderSide(width: 1, color: Colors.black)),
          ),
          onPressed: () {
            setState(() {
              _currentPage = index;
              _pageController.animateToPage(index,
                  duration: Duration(milliseconds: 300), curve: Curves.ease);
            });
          },
          child: Container(
            height: 25,
            alignment: Alignment.center,
            child: Image(
              image: AssetImage(asset),
            ),
          ),
        ),
      ),
    );
  }

  // Tab de Informacion
  Widget _buildSectionInformacion() {
    return loading
        ? ListView()
        : TabInformacion(pokemonDetails: pokemonDetails);
  }

  // Tab de Estadisticas
  Widget _buildSectionEstadisticas() {
    return loading
        ? ListView()
        : TabEstadisticas(pokemonDetails: pokemonDetails);
  }

  // Tab de Evoluciones
  Widget _buildSectionEvoluciones() {
    return loading
        ? ListView()
        : TabEvoluciones(pokemonDetails: pokemonDetails, onSonChanged: updatePokemonFromChild);
  }

  // Tab de Movimientos
  Widget _buildSectionMovimientos() {
    return loading
        ? ListView()
        : TabMovimientos(pokemonDetails: pokemonDetails);
  }

  // AppBar para la pagina de detalles
  AppBar DetailsAppBar() {

    pokemonDetails.name.replaceAll('-', ' ');

    return AppBar(
        title: Text(pokemonDetails.name.substring(0, 1).toUpperCase() + pokemonDetails.name.substring(1).replaceAll('-', ' ')),
        //backgroundColor: Color.fromARGB(255, 202, 0, 16),
        backgroundColor: loading
            ? const Color.fromARGB(255, 202, 0, 16)
            : getColorForElement(pokemonDetails.types[0]),
        actions: [
          Container(
            alignment: Alignment.centerRight,
            child: Text(
              '${pokemonDetails.id}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24),
            ),
          ),

          // Favorite Icon
          IconButton(
            icon: favorite
                ? const Icon(
                    Icons.favorite_outlined,
                    color: Colors.red,
                  )
                : const Icon(Icons.favorite_border_outlined),
            onPressed: () async {
              List<Pokemon> poke = await db.changeFavorite(pokemonDetails.id);
              setState(() {
                favorite = poke[0].favoriteBool();
                onSonChanged(pokemonId, poke[0].favorite);
              });
            },
          ),
        ]);
  }

  // Cargar los detalles del pokemon
  void loadPokemonDetails() async {
    PO.PokemonOnly? pokeOnly;
    PS.PokemonSpecies? pokemonSpecies;
    EC.EvolutionChain? evolutionChain;

    print("\nLoading Pokemon Details\n");
    await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokemonId/')).then((
        response) async {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        pokeOnly = PO.PokemonOnly.fromJson(data);
        print("Success\n");
      } else {
        print("Failure\n");
        setState(() {
          loadingError = true;
        });
        throw Exception('Failed to load details for pokemon $pokemonId}');
      }
    });

    print("Loading Pokemon Species\n");
    await http.get(Uri.parse(pokeOnly!.species.url)).then((response) async {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        pokemonSpecies = PS.PokemonSpecies.fromJson(data);
        print("Success\n");
      } else {
        print("Failure\n");
        setState(() {
          loadingError = true;
        });
        throw Exception('Failed to load details for pokemon $pokemonId}');
      }
    });

    print("Loading Pokemon Evolutions\n");
    await http.get(Uri.parse(pokemonSpecies!.evolutionChain.url)).then((
        response) {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        evolutionChain = EC.EvolutionChain.fromJson(data);
        print("Success\n");
      } else {
        print("Failure\n");
        setState(() {
          loadingError = true;
        });
        throw Exception(
            'Failed to load evolution chain for pokemon $pokemonId}');
      }
    });

    print("Converting DTOs to class\n");
    pokemonDetails = injectDetails(pokeOnly!, pokemonSpecies!, evolutionChain!);

    List<Pokemon> poke = await db.pokemonId(pokemonDetails.id);
    favorite = poke[0].favoriteBool();

    setState(() {
      loading = false;
    });
  }

  void updatePokemonFromChild(int id, int favorite){
    onSonChanged(id, favorite);
  }

  void _openPokemonDetails(BuildContext context, int id) {
    setState(() {});
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PokemonDetailsPage(id: id, onSonChanged: updatePokemonFromChild)),
    );
  }



}
