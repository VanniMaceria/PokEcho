import 'package:flutter/material.dart';
import 'package:pokecho/utils/custom_appbar_back.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarBack(title: "Info"),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  _boxInformazione(
                    "Check the GitHub\n repository",
                    "assets/img/logos/github_logo.svg",
                    'https://github.com/VanniMaceria/PokEcho',
                  ),
                  _boxInformazione(
                    "Follow me on\n Instagram",
                    "assets/img/logos/instagram_logo.svg",
                    'https://www.instagram.com/andrea_bucci18/',
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _launchURL('https://pokeapi.co/');
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.8),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: const Text(
                "This application uses data provided by PokeAPI, a free and open service. We are committed to adhering to PokeAPI's fair usage policy and following guidelines",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _boxInformazione(String text, String imagePath, String url) {
    return GestureDetector(
      onTap: () {
        _launchURL(url);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        height: 100,
        width: double.infinity, //larghezza che si adatta al contenuto
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  width: 70,
                  height: 70,
                  child: SvgPicture.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Errore al lancio di: $url';
    }
  }
}
