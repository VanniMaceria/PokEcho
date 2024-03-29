import 'package:flutter/material.dart';
import 'package:pokecho/utils/url_launcher.dart';

class NoConnection extends StatefulWidget {
  const NoConnection({super.key});

  @override
  State<NoConnection> createState() => _NoConnectionState();
}

class _NoConnectionState extends State<NoConnection> {
  final UrlLauncher _urlLauncher = UrlLauncher();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Missing Internet connection",
              style: TextStyle(color: Colors.black, fontSize: 28),
            ),
            GestureDetector(
              onTap: () {
                _urlLauncher.launchURL("https://storyset.com/data");
              },
              child: Image.asset("assets/img/No connection-bro.png"),
            ), //<a href="https://storyset.com/data">Data illustrations by Storyset</a>
          ],
        ),
      ),
    );
  }
}
