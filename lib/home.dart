import 'package:flutter/material.dart';
import 'package:wachapp/Login.dart';
import 'package:wachapp/search.dart';
import 'package:wachapp/services/auth.dart';

import 'Camara.dart';
import 'Chat.dart';
import 'Estados.dart';
import 'Llamadas.dart';

class Home extends StatefulWidget {
  static final route = 'home';
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController tabController;
  CamaraState camarita = CamaraState();
  Estados estado = Estados();

  void initState() {
    super.initState();
    tabController = TabController(vsync: this, initialIndex: 1, length: 4)
    ..addListener(() {
      setState(() {});
    });
  }

  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TabBar tabBar = TabBar(
      isScrollable: true,
      controller: tabController,
      tabs: [
        Tab(icon: Icon(Icons.camera_alt)),
        Tab(text: 'CHATS'),
        Tab(text: 'ESTADOS'),
        Tab(text: 'LLAMADAS'),
      ],
    );

    /*floatingActionButton(Icon icono) {
      return FloatingActionButton(
        onPressed: () {
          
        },
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple[200],
        child: icono,
      );
    }

    floatingActionButtonStatus(Icon iconoCamara, Icon iconoEdit) {
      return Column(
        children: [
          FloatingActionButton(
            onPressed: () {
          //añadir o cambiar estado
              //Navigator.pushNamed(context, Estados.route);
              //estado._actualizarEstado(context);
            },
          foregroundColor: Colors.white,
          backgroundColor: Colors.purple[200],
          child: iconoEdit,
          ),
          SizedBox(height: 10,),
          FloatingActionButton(onPressed: () {
          //cambiar a f minuscula y luego eliminar hasta child:
            //camarita._mostrarCamara(context);
          },
          foregroundColor: Colors.white,
          backgroundColor: Colors.purple[200],
          child: iconoCamara)
        ],
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
      );
    }*/

     TabBarView tabBarView = TabBarView (
      controller: tabController,
      children: [
        Camara(),
        Chat(),
        Estados(),
        Llamadas()
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Wachapp'),
        bottom: tabBar,
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));
          }
          ),
          IconButton(icon: Icon(Icons.more_vert), onPressed: null),
          GestureDetector(
            onTap: () {
              Auth().cerrarSesion();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage(null)));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: tabBarView,
      /*floatingActionButton: tabController.index == 1 ? floatingActionButton(Icon(
        Icons.message)) : tabController.index == 2 ?
        floatingActionButtonStatus(Icon(Icons.edit), Icon(Icons.camera_alt))
        : tabController.index == 3 ? 
        floatingActionButton(Icon(Icons.add_call)) : Container()*/
    );
  }

}