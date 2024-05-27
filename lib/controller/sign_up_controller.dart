import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pokecho/model/auth.dart';
import 'package:pokecho/screens/log_in.dart';

class SignUpController {
  SignUpController();

  Future<void> signUp(
      {required BuildContext context,
      required TextEditingController email,
      required TextEditingController password}) async {
    try {
      await Auth().createUserWithEmailAndPassword(
          email: email.text, password: password.text);
      //vai a login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LogIn()),
      );
    } on FirebaseAuthException catch (error) {
      String errorMessage;

      switch (error.code) {
        case 'email-already-in-use':
          errorMessage =
              'The email address is already in use by another account';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid';
          break;
        case 'operation-not-allowed':
          errorMessage = 'The operation is not allowed\nContact support';
          break;
        case 'weak-password':
          errorMessage = 'The password is too weak';
          break;
        default:
          errorMessage = 'An error occurred\nTry later.';
      }

      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.asset(
                    "assets/gif/porygon2_sprite.gif",
                    height: 100,
                    width: 100,
                  ),
                ],
              ),
            );
          });
    }
  }
}
