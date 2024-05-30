import 'package:flutter/material.dart';
import '../controller/sign_up_controller.dart';
import 'package:pokecho/utils/url_launcher.dart';
import 'package:pokecho/utils/custom_form.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final UrlLauncher _urlLauncher = UrlLauncher();
  final SignUpController _signUpController = SignUpController();

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              //stop
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
                    child: Image.asset("assets/img/Server status-bro.png"),
                  ),
                  SizedBox(height: screenHeight * 0.1),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomForm(
                          emailController: _emailController,
                          passwordController: _passwordController,
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
                                _signUpController.signUp(
                                  context: context,
                                  email: _emailController,
                                  password: _passwordController,
                                );
                              }
                            },
                            child: Text(
                              "Sign-Up",
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
