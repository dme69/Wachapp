import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
//import 'package:camera/camera.dart';

class Camara extends StatefulWidget {
  @override
  CamaraState createState() => CamaraState();
}

class CamaraState extends State<Camara> {
  File imagenArchivo;

  void _abrirCamara(BuildContext context) async {
    var imagen = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imagenArchivo = imagen;
    });
    Navigator.of(context).pop();
  }

  void _abrirGaleria(BuildContext context) async {
    var imagen = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imagenArchivo = imagen;
    });
    Navigator.of(context).pop();
  }

  @override
  Future<void> _mostrarCamara(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Elige:"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    child: Text("Galeria"),
                    onTap: () {
                      _abrirGaleria(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    child: Text("Camara"),
                    onTap: () {
                      _abrirCamara(context);
                    },
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarCamara(context);
        },
        child: Icon(Icons.camera_alt),
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple[200],
      )
    );
  }
}