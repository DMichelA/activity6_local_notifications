import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'secondPage.dart';
import 'main.dart';

class homePage extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<homePage> {
  //VARIABLES REFERENTES AL MANEJO DE LA BD

  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final TextEditingController _usuario = new TextEditingController();

  final formKey = new GlobalKey<FormState>();

  //PARA SABER ESTADO ACTUAL DE LA CONSULTA

  @override
  void initState() {
    super.initState();
    _redirectionAnalisis();
  }

  void cleanData() {
    _email.text = "";
    _password.text = "";
    _usuario.text = "";
  }

  //FORMULARIO
  Widget form() {
    return SingleChildScrollView(
        child: Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: new SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              new SizedBox(height: 50.0),
              TextFormField(
                enabled: true,
                controller: _email,
                validator: (valor) =>
                    valor.contains("@") == false ? "Not a valid E-mail" : null,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "E-mail",
                  hintStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.lightBlue,
                      width: 2,
                    ),
                  ),
                  border: OutlineInputBorder(
                    //No desaparece el borde
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(),
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(
                      left: 30,
                      right: 30,
                    ),
                    child: Icon(Icons.mail),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                enabled: true,
                controller: _password,
                validator: (val2) =>
                    val2.length == 0 ? "Field can't be empty" : null,
                obscureText: true,
                //Ocultar contraseña
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.lightBlue,
                      width: 2,
                    ),
                  ),
                  border: OutlineInputBorder(
                    //No desaparece el borde
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(),
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(
                      left: 30,
                      right: 30,
                    ),
                    child: Icon(Icons.lock),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                enabled: true,
                controller: _usuario,
                validator: (val3) =>
                    val3.length == 0 ? "Field can't be empty" : null,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "UserName",
                  hintStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.lightBlue,
                      width: 2,
                    ),
                  ),
                  border: OutlineInputBorder(
                    //No desaparece el borde
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(),
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(
                      left: 30,
                      right: 30,
                    ),
                    child: Icon(Icons.person),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 60,
                    child: RaisedButton(
                      onPressed: _registro,
                      //SI ESTA LLENO ACTUALIZAR, SI NO AGREGAR
                      color: Colors.lightBlue,
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Future<void> _redirectionAnalisis() async {
    final sharepref = await SharedPreferences.getInstance();
    var email = sharepref.getString("email");
    var user = sharepref.getString("usuario");
    var pass = sharepref.getString("password");
    print(email);
    setState(() {
      if ((user != null) && (pass != null) && (email != null)) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => LocalNotification()));
      }
    });
  }

  Future<void> _registro() async {
    final sharepref = await SharedPreferences.getInstance();
    var email = _email.text;
    var user = _usuario.text;
    var pass = _password.text;
    print("oye");
    print(email);
    print(user);
    print(pass);
    if ((user == "") || (pass == "") || (email == "")) {
      await sharepref.setString('email', null);
      await sharepref.setString('usuario', null);
      await sharepref.setString('password', null);
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
    } else {
      if (email.contains("@")) {
        await sharepref.setString('email', email);
        await sharepref.setString('usuario', user);
        await sharepref.setString('password', pass);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => LocalNotification()));
      } else {
        _showSnackbar(context, "Not a valid E-mail");
      }
    }
    setState(() {});
  }

  final _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        key: _scaffoldkey,
        appBar: new AppBar(
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          title: Text('Sign In',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5),
              child: Center(
                child: Container(width: 100, height: 30),
              ),
            ),
            new Center(
              child: Container(
                height: 150,
                width: 150,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      image: new NetworkImage(
                          "https://www.daarts.org/wp-content/uploads/2019/02/individual.png"),
                      fit: BoxFit.fill),
                ),
              ),
            ),
            Container(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  form(),
                ],
              ),
            )
          ],
        ));
  }

  _showSnackbar(BuildContext context, String texto) {
    final snackBar = SnackBar(
        backgroundColor: Colors.redAccent,
        content: new Text(texto,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontFamily: 'Schyler',
              fontWeight: FontWeight.bold,
            )));
    _scaffoldkey.currentState.showSnackBar(snackBar);
  }
}
