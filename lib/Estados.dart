import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Estados extends StatefulWidget {
  @override
  EstadosState createState() => EstadosState();
}



class EstadosState extends State<Estados> {
  File imagenArchivo;

  Future<void> _actualizarEstado(BuildContext context) {
  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //final estado = "";
  /*return Scaffold(
   body: showDialog(
    child: TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: 'Actualice su estado'
  ),),),);    */
  /*
  body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
  */
  }
      //Navigator.pop(context);
    


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
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Column(
        children: [
          FloatingActionButton(
            onPressed: () {
              _mostrarCamara(context);
            },
            child: Icon(Icons.camera_alt),
            foregroundColor: Colors.white,
            backgroundColor: Colors.purple[200],
          ),
          SizedBox(height: 10,),
          FloatingActionButton(
            onPressed: () {
              //_actualizarEstado(context);
            },
            child: Icon(Icons.edit),
            foregroundColor: Colors.white,
            backgroundColor: Colors.purple[200],
          ),
          SizedBox(height: 20,),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
      ),
    );
  }
}