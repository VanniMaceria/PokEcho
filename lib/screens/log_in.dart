import 'package:flutter/material.dart';
import 'package:pokecho/controller/log_in_controller.dart';
import 'package:pokecho/utils/custom_form.dart';
import 'package:pokecho/utils/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class LogIn extends StatefulWidget {
  LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final LogInController _logInController = LogInController();
  final UrlLauncher _urlLauncher = UrlLauncher();
  late final SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  void _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 25.0),
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _urlLauncher.launchURL("https://storyset.com/data");
                    },
                    child: Image.asset("assets/img/Mobile login-bro.png"),
                  ),
                  SizedBox(height: screenHeight * 0.1),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomForm(
                            emailController: _emailController,
                            passwordController: _passwordController),
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
                                //salvo le credenziali con SharedPreferences, serve per mantenere l'utente loggato
                                _prefs.setBool("login", true);
                                _prefs.setString(
                                    "email", _emailController.text);
                                _prefs.setString(
                                    "password", _passwordController.text);

                                _logInController.logIn(
                                  context: context,
                                  email: _emailController,
                                  password: _passwordController,
                                );
                              }
                            },
                            child: Text(
                              "Log-In",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
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
