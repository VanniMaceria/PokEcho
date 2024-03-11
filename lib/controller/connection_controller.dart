import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:pokecho/main.dart';
import '../screens/no_connection.dart';

class ConnectionController {
  late Connectivity _connectivity;
  late bool isConnected;
  late GlobalKey<NavigatorState> navigatorKey;

  ConnectionController({required this.navigatorKey}) {
    _connectivity = Connectivity();
    isConnected = false;

    // Ascolto le modifiche di stato
    _connectivity.onConnectivityChanged.listen((result) {
      isConnected = result != ConnectivityResult.none;
      print("Stato connessione: $isConnected");
      if (isConnected) {
        // Se la connessione è stata ripristinata, torna alla pagina Home
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (context) => const RootPage()),
        );
      } else {
        // Se la connessione è assente, vai alla pagina NoConnection
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (context) => const NoConnection()),
        );
      }
    });

    // Eseguo il controllo di connettività iniziale
    _connectivity.checkConnectivity().then((result) {
      isConnected = result != ConnectivityResult.none;
      if (!isConnected) {
        // Se la connessione è assente all'avvio dell'app, vai alla pagina NoConnection
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (context) => const NoConnection()),
        );
      }
    });
  }
}
