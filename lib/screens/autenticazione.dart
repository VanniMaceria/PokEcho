import 'package:flutter/material.dart';
import 'package:pokecho/screens/log_in.dart';
import 'package:pokecho/screens/sign_up.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Autenticazione extends StatelessWidget {
  Autenticazione({super.key});

  @override
  Widget build(BuildContext context) {
    // Dimensioni schermo dell'80% (larghezza)
    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonWidth = screenWidth * 0.8;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFD02525),
      body: Stack(
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
                Container(
                  margin: EdgeInsets.only(
                      top: screenHeight * 0.4, left: 16, right: 16),
                  width: buttonWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "STAY",
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            fontSize: 40.0,
                            color: Colors.white,
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              FadeAnimatedText(
                                'CONNECTED',
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              FadeAnimatedText(
                                'UPDATED',
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              FadeAnimatedText(
                                'COMPETITIVE',
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                            repeatForever: true,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Log-in or register to save your scores and enter the leaderboard",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
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
