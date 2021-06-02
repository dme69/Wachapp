import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wachapp/ForgotPassword.dart';
import 'package:wachapp/HelperFunctions.dart';
import 'package:wachapp/registerPage.dart';
import 'package:wachapp/services/auth.dart';
import 'package:wachapp/services/database.dart';
import 'home.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';


class LoginPage extends StatefulWidget {
  static final route = "/loginPage";
  final Function toggleView;

  LoginPage(this.toggleView);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  Auth authService = new Auth();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  signIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authService
          .signInWithEmailAndPassword(
              emailEditingController.text, passwordEditingController.text)
          .then((result) async {
        if (result != null)  {
          QuerySnapshot userInfoSnapshot =
              await Database().getUserInfo(emailEditingController.text);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(userInfoSnapshot.documents[0].data["userName"]);
          HelperFunctions.saveUserEmailSharedPreference(userInfoSnapshot.documents[0].data["userEmail"]);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        } else {
          setState(() {
            isLoading = false;
            //show snackbar
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wachapp'),
      ),
      body: isLoading ? Container(
              child: Center(child: CircularProgressIndicator()),
            ) : Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Spacer(),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val)
                                ? null
                                : "Please Enter Correct Email";//REVISION
                          },
                          controller: emailEditingController,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          decoration: InputDecoration(
                      hintText: ("Email"),
                      hintStyle: TextStyle(color: Colors.white54),
                      focusedBorder:
                        UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)
                        ),
                      enabledBorder:
                        UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)
                        )
                    ),
                        ),
                        TextFormField(
                          obscureText: true,
                          validator: (val) {
                            return val.length > 3 ? null : "Introduce una contraseña de más de 3 caracteres";
                          },
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          controller: passwordEditingController,
                          decoration: InputDecoration(
                          hintText: ("Contraseña"),
                          hintStyle: TextStyle(color: Colors.white54),
                          focusedBorder:
                            UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)
                            ),
                          enabledBorder:
                            UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)
                            )
                        ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword()));
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              "¿Ha olvidado su contraseña?",
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            )),
                      )
                    ],
                  ),
                  SizedBox(height: 16,),
                  GestureDetector(
                    onTap: () {
                      signIn();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xff007EF4),
                              const Color(0xff2A75BC)
                            ],
                          )),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 16,),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Login con Google",
                      style: TextStyle(fontSize: 17, color: Color(0xff071930)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "¿No tiene una cuenta?",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.toggleView();
                        },
                        child: Text(
                          "Registrate ahora",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50,)
                ],
              ),
            ),
    );
  }
}

/*  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.purple[400], Colors.teal],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: _isLoading ? Center(
          child: CircularProgressIndicator()) : ListView(
          children: <Widget>[
            headerSection(),
            textSection(),
            buttonSection(),
          ],
        ),
      ),
    );
  }

  Container buttonSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: Column(
        children: [
          RaisedButton(
            onPressed: emailController.text == "" || passwordController.text == "" ? null : () {
            
              Navigator.pushNamed(context, Home.route); 
            
              /*setState(() {
                Navigator.pushNamed(context, Home.route);
                //_isLoading = true;
              });
              login(emailController.text, passwordController.text);*/
            },
            elevation: 0.0,
            color: Colors.purple,
            child: Text("Iniciar Sesión", style: TextStyle(color: Colors.white70)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          ),
          RaisedButton(
            onPressed: () => Navigator.pushNamed(context, RegisterPage.route),
            elevation: 0.0,
            color: Colors.purple,
            child: Text("Registrarse", style: TextStyle(color: Colors.white70)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          ),
        ],
      ),
    );
  }

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: emailController,
            cursorColor: Colors.white,

            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.email, color: Colors.white70),
              hintText: "Email",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            controller: passwordController,
            cursorColor: Colors.white,
            obscureText: true,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.white70),
              hintText: "Password",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Text("Inicio de Sesión",
          style: TextStyle(
              color: Colors.white70,
              fontSize: 40.0,
              fontWeight: FontWeight.bold)),
    );
  }
}*/