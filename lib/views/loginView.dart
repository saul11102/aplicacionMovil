//fstful
import 'dart:developer';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:validators/validators.dart';
import 'package:productos_app/controllers/Service.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  //validadores de texo
  final TextEditingController usuarioControl = TextEditingController();
  final TextEditingController claveControl = TextEditingController();

  //método para validación de campos de formulario y envio de data
  void iniciarValidadores() {
    FToast ftoast = FToast();
    ftoast.init(context);

    setState(() {
      if (_formKey.currentState!.validate()) {
        Map<String, String> data = {
          "usuario": usuarioControl.text,
          "clave": claveControl.text
        };
        print(data.toString());
        Service c = Service();
        c.session(data).then((value) async {
          print(value.toString());
          if (value.code == '200') {
            ftoast.showToast(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.green.shade900),
                  child: Text("Bienvenido: " + value.user,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 15)),
                ),
                gravity: ToastGravity.CENTER,
                toastDuration: const Duration(seconds: 3));

            Navigator.pushReplacementNamed(context, '/dashboard');
          } else {
            ftoast.showToast(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.red.shade900),
                  child: Text(value.datos['error'],
                      style:
                          const TextStyle(color: Colors.white, fontSize: 15)),
                ),
                gravity: ToastGravity.CENTER,
                toastDuration: const Duration(seconds: 3));
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200, // Light background color
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // Stretch widgets horizontally
              children: [
                // App logo or title (replace with your desired logo)
                Icon(
                  Icons
                      .person, // Puedes cambiar este icono por otro de la biblioteca de Flutter
                  size: 50,
                  color: Colors.grey[800],
                ),
                const SizedBox(height: 24.0),
                Text(
                  'Productos_app',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  controller: usuarioControl,
                  decoration: InputDecoration(
                    labelText: 'Usuario',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Ingrese su usuario";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  controller: claveControl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Clave',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Ingrese su clave";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: iniciarValidadores,
                  child: const Text('Iniciar sesión'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(
                        50.0), // Set minimum button height
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded button corners
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
