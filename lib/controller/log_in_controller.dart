import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pokecho/model/auth.dart';
import '../screens/utente.dart';
import 'package:pokecho/controller/ricerca_controller.dart';

class LogInController {
  final RicercaController _ricercaController = RicercaController();

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
        case 'invalid-credential':
          errorMessage = "Incorrect credentials";
        default:
          errorMessage = error.code.toLowerCase();
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
                GestureDetector(
                  onTap: () async {
                    var json = await _ricercaController
                        .fetchPokemonDetails(201); //id unown
                    _ricercaController.riproduciVerso(json);
                  },
                  child: Image.asset(
                    "assets/gif/unown_sprite.gif",
                    height: 100,
                    width: 100,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
