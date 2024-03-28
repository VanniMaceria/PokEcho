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
      body: SingleChildScrollView(
        child: Column(
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // Per evitare conflitti con SingleChildScrollView
              children: [
                _boxInformazione(
                  "Check the GitHub\nrepository",
                  "assets/img/logos/github_logo.svg",
                  'https://github.com/VanniMaceria/PokEcho',
                ),
                _boxInformazione(
                  "Follow me on\nInstagram",
                  "assets/img/logos/instagram_logo.svg",
                  'https://www.instagram.com/andrea_bucci18/',
                ),
                _boxInformazione(
                  "Developed in\nDart",
                  "assets/img/logos/dart_logo.svg",
                  'https://dart.dev/',
                ),
                _boxAlertInformazioni("Contacts", "andreabucci123@gmail.com"),
                _boxAlertInformazioni(
                    "Permissions",
                    ' - INTERNET PERMISSION: This permission allows the application to access Internet to download data, send API requests, and communicate with external servers. It is necessary if the application needs to retrieve information from online sources or interact with web services;\n\n'
                        ' - QUERY_ALL_PACKAGES: This permission allows the app to access package information from other apps. It is required to sync data with other apps or integrate with third-party services. For example, it allows you to open applications outside the main application.'),
                _boxAlertInformazioni("Artistic credits",
                    "The illustrations used in this application are provided by © Storyset.\nFor further information and to discover more fantastic resources, visit www.storyset.com\n\nThe Pokémon information used in this application is provided by The Pokémon Company.\nAll rights to Pokémon are owned by The Pokémon Company. For more information about Pokémon and their properties, visit The Pokémon Company's official website at www.pokemon.com.")
              ],
            ),
            GestureDetector(
              onTap: () {
                _launchURL('https://pokeapi.co/');
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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

  Widget _boxAlertInformazioni(String titolo, String contenuto) {
    return GestureDetector(
      onTap: () {
        //mostra un BottomSheet
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    titolo,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    contenuto,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
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
            ),
          ],
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              titolo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
              ),
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
