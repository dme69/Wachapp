import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wachapp/Chat.dart';
import 'package:wachapp/HelperFunctions.dart';
import 'package:wachapp/Login.dart';
import 'package:wachapp/services/auth.dart';
import 'package:wachapp/services/database.dart';
import 'home.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';

class RegisterPage extends StatefulWidget {
  static final String route = "/registerPage";
  // Register({Key key}) : super(key: key);
  final Function toggleView;
  RegisterPage(this.toggleView);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController usernameEditingController = new TextEditingController();

  Auth authService = new Auth();
  Database databaseMethods = new Database();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  singUp() async {

    if(formKey.currentState.validate()){
      setState(() {
        isLoading = true;
      });

      await authService.regitrarseConEmailAndPassword(emailEditingController.text,
          passwordEditingController.text).then((result){
            if(result != null){

              Map<String,String> userDataMap = {
                "userName" : usernameEditingController.text,
                "userEmail" : emailEditingController.text
              };

              databaseMethods.addUserInfo(userDataMap);

              HelperFunctions.saveUserLoggedInSharedPreference(true);
              HelperFunctions.saveUserNameSharedPreference(usernameEditingController.text);
              HelperFunctions.saveUserEmailSharedPreference(emailEditingController.text);

              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => Home()
              ));
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
      body: isLoading ? Container(child: Center(child: CircularProgressIndicator(),),) :  Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Spacer(),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    controller: usernameEditingController,
                    validator: (val){
                      return val.isEmpty || val.length < 3 ? "El usuario debe de tener mas de 3 caracteres" : null;
                    },
                    decoration: InputDecoration(
                      hintText: ("Nombre de usuario"),
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
                    controller: emailEditingController,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    validator: (val){
                      return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                          null : "Enter correct email";//REVISION
                    },
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
                    style: TextStyle(color: Colors.white, fontSize: 16),
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
                    controller: passwordEditingController,
                    validator:  (val){
                      return val.length < 3 ? "La contraseña debe de tener más e 3 caracteres" : null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16,),
            GestureDetector(
              onTap: (){
                singUp();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [const Color(0xff007EF4), const Color(0xff2A75BC)],
                    )),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "Registrarse",
                  style: TextStyle(color: Colors.white, fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 16,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30), color: Colors.white),
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Registrarse con Google",
                style: TextStyle(fontSize: 17, color: Color(0xff071930)),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "¿No tienes cuenta?",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                GestureDetector(
                  onTap: () {
                    widget.toggleView();
                  },
                  child: Text(
                    "SignIn now",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}








  /*final formKey = GlobalKey<FormState>();
  bool _isLoading = false;

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
              Auth.signInWithEmailAndPassword(String emailController.text, String password);
            },
            elevation: 0.0,
            color: Colors.purple,
            child: Text("Registrarse", style: TextStyle(color: Colors.white70)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          ),
          RaisedButton(
            onPressed: () => Navigator.pushNamed(context, LoginPage.route),
            elevation: 0.0,
            color: Colors.purple,
            child: Text("Cancelar", style: TextStyle(color: Colors.white70)),
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
          SizedBox(height: 30.0),
          TextFormField(
            cursorColor: Colors.white,
            obscureText: true,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.person, color: Colors.white70),
              hintText: "Nombre",
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
      child: Text("Registro de Usuario",
          style: TextStyle(
              color: Colors.white70,
              fontSize: 40.0,
              fontWeight: FontWeight.bold)),
    );
  }
}*/