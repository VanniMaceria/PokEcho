import 'package:flutter/material.dart';
import 'package:pokecho/controller/ricerca_controller.dart';
import 'package:pokecho/utils/url_launcher.dart';

class Ricerca extends StatefulWidget {
  const Ricerca({Key? key}) : super(key: key);

  @override
  State<Ricerca> createState() => _RicercaState();
}

class _RicercaState extends State<Ricerca> {
  final TextEditingController _textEditingController =
      TextEditingController(); //widget che serve ad estrarre il testo da un TextField
  final RicercaController _ricercaController = RicercaController();
  late Future<Map<String, dynamic>>? _searchResult = Future.value({});
  final UrlLauncher _urlLauncher = UrlLauncher();

  @override
  void initState() {
    super.initState();
    _searchResult = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: const Color(0xFFD02525),
            height: 130,
            padding: const EdgeInsets.only(top: 45),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller:
                          _textEditingController, //assegno il controller al TextField
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Cerca per nome o id',
                          filled: true,
                          fillColor: Colors.white),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Estraggo il testo
                    if (_textEditingController.text.isNotEmpty) {
                      setState(() {
                        _searchResult = _ricercaController.fetchPokemonDetails(
                            _textEditingController.text
                                .toLowerCase()); //l'api non funziona se i nomi non sono in lowercase
                      });
                    } else {
                      // Se il campo di ricerca è vuoto, assegna un valore vuoto a _searchResult
                      setState(() {
                        _searchResult = null;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFAF9F6),
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(10),
                    shadowColor: const Color(0xFFD02525),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Color(0xFFD02525),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    if (_searchResult != null)
                      FutureBuilder<Map<String, dynamic>>(
                        future: _searchResult,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError ||
                              snapshot.data == null ||
                              snapshot.data!.isEmpty) {
                            //se si verifica un errore o non ci sono dati validi
                            //mostro l'immagine di errore
                            return Center(
                              child: Column(
                                children: [
                                  Text(
                                    "No result for '${_textEditingController.text}'",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 28),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _urlLauncher.launchURL(
                                          "https://storyset.com/data");
                                    },
                                    child: Image.asset(
                                        "assets/img/No data-bro.png"),
                                  ), //<a href="https://storyset.com/data">Data illustrations by Storyset</a>
                                  const Text(
                                    "Are you sure it's a Pokèmon?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 28),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            final pokemonData = snapshot.data!;
                            final String spriteUrl = pokemonData['sprites']
                                ['other']['official-artwork']['front_default'];
                            return Image.network(spriteUrl);
                          }
                        },
                      ),
                    const SizedBox(height: 20),
                    if (_searchResult != null)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFAF9F6),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(18),
                          shadowColor: const Color(0xFFD02525),
                        ),
                        onPressed: () {
                          _searchResult?.then((pokemonData) {
                            _ricercaController.riproduciVerso(pokemonData);
                          });
                        },
                        child: const Icon(
                          Icons.play_arrow_outlined,
                          color: Color(0xFFD02525),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _ricercaController.getAudioPlayer().dispose();
    super.dispose();
  }
}
