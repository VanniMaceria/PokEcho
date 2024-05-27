import 'package:flutter/material.dart';
import 'package:pokecho/controller/log_in_controller.dart';
import 'package:pokecho/controller/ricerca_controller.dart';
import 'package:pokecho/utils/custom_appbar_back.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final RicercaController _ricercaController = RicercaController();
  final LogInController _logInController = LogInController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarBack(title: "Log-In"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Image.asset("assets/img/707_klefki.png"),
                  onTap: () async {
                    try {
                      var json =
                          await _ricercaController.fetchPokemonDetails(707);
                      _ricercaController.riproduciVerso(json);
                    } catch (e) {
                      print('Failed to fetch Pokemon details: $e');
                    }
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFFD02525),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Process data
                        _logInController.logIn(
                          context: context,
                          email: _emailController,
                          password: _passwordController,
                        );
                      }
                    },
                    child: Text(
                      "Log-In",
                      style: TextStyle(color: Colors.white, fontSize: 20),
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
