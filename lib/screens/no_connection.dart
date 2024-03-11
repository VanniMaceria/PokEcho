import 'package:flutter/material.dart';

class NoConnection extends StatelessWidget {
  const NoConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Nessuna connessione Internet",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            Icon(
              Icons.wifi_off_outlined,
              color: Color(0xFFD02525),
              size: 180,
            ),
          ],
        ),
      ),
    );
  }
}
