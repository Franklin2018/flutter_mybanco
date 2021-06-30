import 'package:flutter/material.dart';
import 'package:flutter_mybanco/models/user.dart';
import 'package:flutter_mybanco/pages/homePage.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  User user = User('', '');

  var url = Uri.parse('http://192.168.1.108:3000/login');

  Future login() async {
    var response = await http.post(url,
        body: {'correo': user.correo, 'contrasena': user.contrasena});
    print('Response status: ${response.statusCode}');
    print(response.body);
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => HomePage()));
  }

  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: 0,
              child: SvgPicture.asset(
                'images/logo.svg',
                width: 400,
                height: 150,
              )),
          Container(
            alignment: Alignment.center,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 150,
                    ),
                    Text(
                      "Singin",
                      style: GoogleFonts.pacifico(
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                          color: Colors.blue),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                          controller: TextEditingController(text: user.correo),
                          onChanged: (value) {
                            user.correo = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'ingrese su correo';
                            } else if (RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                              return null;
                            } else {
                              return 'Enter valid email';
                            }
                          },
                          decoration: myDecoration(Icons.email, "Enter Email")),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller:
                            TextEditingController(text: user.contrasena),
                        onChanged: (value) {
                          user.contrasena = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'ingrese su contraseña';
                          }
                          return null;
                        },
                        decoration: myDecorationPassword(
                            Icons.vpn_key, "Enter Password"),
                        obscureText: _obscureText,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(55, 16, 16, 0),
                      child: Container(
                        height: 50,
                        width: 400,
                        child: ElevatedButton(
                            style: style,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                login();
                                print("ok");
                              } else {
                                print("not ok");
                              }
                            },
                            child: Text(
                              "Signin",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  myDecoration(IconData iconData, String hint) {
    return InputDecoration(
        icon: Icon(iconData),
        hintText: hint,
        enabledBorder: enabledB(),
        focusedBorder: focusedB(),
        errorBorder: errorB(),
        focusedErrorBorder: focusedErrorB());
  }

  myDecorationPassword(IconData iconData, String hint) {
    return InputDecoration(
        icon: Icon(iconData),
        hintText: hint,
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.remove_red_eye : Icons.security),
          onPressed: () {
            _toggle();
          },
        ),
        enabledBorder: enabledB(),
        focusedBorder: focusedB(),
        errorBorder: errorB(),
        focusedErrorBorder: focusedErrorB());
  }

  enabledB() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.blue));
  }

  focusedB() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.blue));
  }

  errorB() {
    OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.red));
  }

  focusedErrorB() {
    OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.red));
  }
}
