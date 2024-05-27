import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pokecho/model/auth.dart';

import '../screens/utente.dart';

class LogInController {
  LogInController();

  Future<void> logIn(
      {required BuildContext context,
      required TextEditingController email,
      required TextEditingController password}) async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: email.text, password: password.text);
      //vai alla pagina Utente
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Utente()),
      );
    } on FirebaseAuthException catch (error) {
      String errorMessage;

      switch (error.code) {
        case 'invalid-email':
          errorMessage = 'Invalid email';
          break;
        case 'user-disabled':
          errorMessage = 'The user with this email address has been disabled';
          break;
        case 'user-not-found':
          errorMessage = 'There is no user with this email address';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password';
          break;
        default:
          errorMessage = 'An error occurred\nTry later';
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
                ]),
          );
        },
      );
    }
  }
}
