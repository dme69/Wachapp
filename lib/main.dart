import 'package:flutter/material.dart';

import 'home.dart';
import 'Login.dart';

void main() {
  runApp(Wachapp());
}

class Wachapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wachapp',
      theme: ThemeData(
        primaryColor: Colors.purple[400],
      ),
      home: LoginPage(null),
    );
  }
}

