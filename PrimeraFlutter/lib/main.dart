import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Aprendiendo sobre Widget'),
          backgroundColor: Colors.blue,
        ),
        body: MyWidget(),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String texto = 'Hola Mundo';
  bool cambiado = false;
  TextStyle estilo = const TextStyle(fontSize: 24.0, color: Colors.green);
  Color col = Colors.orange;
  Image imagen = Image.asset('assets/chat.png');

  void changeText() {
    setState(() {
      if (cambiado) {
        texto = 'Hola Mundo';
        estilo = const TextStyle(fontSize: 24.0, color: Colors.green);
        imagen = Image.asset("assets/chat.png");
        col = Colors.orange;
      } else {
        texto = 'Adios Mundo';
        estilo = const TextStyle(fontSize: 24.0, color: Colors.lightBlueAccent);
        imagen = Image.asset("assets/chatAzul.png");
        col = Colors.pink ;
      }
      cambiado = !cambiado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.all(16.0),
            width: 100,
            height: 100,
            child: imagen,
          ),
        ),
        Text(
          texto,
          style: estilo,
        ),
        const SizedBox(height: 20.0),
        ElevatedButton(
        onPressed: changeText,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              return col;
            }),
          ),child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.edit_note),
              SizedBox(width: 8.0),
              Text('Cambiar'),
            ],
          ),
        ),
      ],
    );
  }
}
