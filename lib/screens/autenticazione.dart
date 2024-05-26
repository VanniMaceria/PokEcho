import 'package:flutter/material.dart';
import 'package:pokecho/screens/log_in.dart';
import 'package:pokecho/screens/sign_up.dart';
import 'package:pokecho/utils/url_launcher.dart';

class Autenticazione extends StatelessWidget {
  Autenticazione({super.key});

  final UrlLauncher _urlLauncher = UrlLauncher();

  @override
  Widget build(BuildContext context) {
    //dimensioni schermo dell'80%
    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonWidth = screenWidth * 0.8;

    return Scaffold(
      backgroundColor: Color(0xFFD02525),
      body: Stack(
        //By default, the non-positioned children of the stack are aligned by their top left corners
        children: [
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _urlLauncher.launchURL("https://storyset.com/data");
                  },
                  child: Image.asset("assets/img/Mobile login-bro.png"),
                ),
                SizedBox(height: 80), // Spacing between the image and buttons
                Container(
                  height: 50,
                  width: buttonWidth,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LogIn()),
                      );
                    },
                    child: Text(
                      "Log-In",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(height: 10), // Spacing between the buttons
                Container(
                  height: 50,
                  width: buttonWidth,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                    child: Text(
                      "Sign-Up",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
