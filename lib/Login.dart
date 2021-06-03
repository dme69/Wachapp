import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wachapp/ForgotPassword.dart';
import 'package:wachapp/HelperFunctions.dart';
import 'package:wachapp/registerPage.dart';
import 'package:wachapp/services/auth.dart';
import 'package:wachapp/services/database.dart';
import 'home.dart';


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
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
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
                                : "Por favor introduce un email correcto";//REVISION
                          },
                          controller: emailEditingController,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          decoration: InputDecoration(
                      hintText: ("Email"),
                      hintStyle: TextStyle(color: Colors.black),
                      focusedBorder:
                        UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)
                        ),
                      enabledBorder:
                        UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)
                        )
                    ),
                        ),
                        TextFormField(
                          obscureText: true,
                          validator: (val) {
                            return val.length > 3 ? null : "Introduce una contraseña de más de 3 caracteres";
                          },
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          controller: passwordEditingController,
                          decoration: InputDecoration(
                          hintText: ("Contraseña"),
                          hintStyle: TextStyle(color: Colors.black),
                          focusedBorder:
                            UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)
                            ),
                          enabledBorder:
                            UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)
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
                              style: TextStyle(color: Colors.black, fontSize: 16),
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
                        "¿No tiene una cuenta? ",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          //widget.toggleView();
                          Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => RegisterPage(null)));
                        },
                        child: Text(
                          " Registrate ahora",
                          style: TextStyle(
                              color: Colors.black,
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