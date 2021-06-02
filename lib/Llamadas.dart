import 'package:flutter/material.dart';

class Llamadas extends StatefulWidget {
  @override
  LlamadasState createState() => LlamadasState();
}

class LlamadasState extends State<Llamadas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //_mostrarCamara(context);
          //https://github.com/robertodevs/contactpicker
        },
        child: Icon(Icons.add_call),
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple[200],
      )
    );
  }
}