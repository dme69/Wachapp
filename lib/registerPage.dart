import 'package:flutter/material.dart';
import 'package:wachapp/HelperFunctions.dart';
import 'package:wachapp/Login.dart';
import 'package:wachapp/services/auth.dart';
import 'package:wachapp/services/database.dart';
import 'home.dart';

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
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    controller: usernameEditingController,
                    validator: (val){
                      return val.isEmpty || val.length < 3 ? "El usuario debe de tener mas de 3 caracteres" : null;
                    },
                    decoration: InputDecoration(
                      hintText: ("Nombre de usuario"),
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
                    controller: emailEditingController,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    validator: (val){
                      return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                          null : "Introduce un email correcto";
                    },
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
                    style: TextStyle(color: Colors.black, fontSize: 16),
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
                  "¿Ya tienes cuenta? ",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                GestureDetector(
                  onTap: () {
                    //widget.toggleView();
                    Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => LoginPage(null)));
                  },
                  child: Text(
                    " Logueate",
                    style: TextStyle(
                        color: Colors.black,
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