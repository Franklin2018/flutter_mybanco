import 'package:flutter/material.dart';
import 'package:flutter_mybanco/models/retiro.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  Retiro myretiro = Retiro('', 0);

  var url = Uri.parse('http://192.168.1.108:3000/crearretiro');

  Future crearRetiro() async {
    var response = await http.post(url, body: {
      'nrocuenta': myretiro.nrocuenta,
      'monto': myretiro.monto.toString()
    });
    print('Response status: ${response.statusCode}');
    print(response.body);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Datos procesados')));
  }

  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Realizar Retiro'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
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
                      height: 100,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                          controller:
                              TextEditingController(text: myretiro.nrocuenta),
                          onChanged: (value) {
                            myretiro.nrocuenta = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'ingrese nro. de cuenta';
                            }
                            return null;
                          },
                          decoration: myDecoration(
                              Icons.account_balance, "Enter cuenta")),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                          controller: TextEditingController(
                              text: myretiro.monto.toString()),
                          onChanged: (value) {
                            myretiro.monto = int.parse(value);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'ingrese un monto a retirar';
                            }
                            return null;
                          },
                          decoration: myDecoration(Icons.monetization_on_sharp,
                              "Enter monto a retirar")),
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
                                crearRetiro();
                                print("ok");
                              } else {
                                print("not ok");
                              }
                            },
                            child: Text(
                              "Retirar Dinero",
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
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.blue)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.blue)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.red)));
  }
}
