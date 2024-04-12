import 'package:pokecho/controller/connection_controller.dart';
import 'package:pokecho/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:pokecho/utils/custom_appbar.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeController _homeController = HomeController();
  // ignore: unused_field
  late ConnectionController _connectionController;
  int _score = 0;
  late Future<int> _indexCurrentPkmn;
  late SharedPreferences _prefs;
  int _bestScore = 0;
  bool _playButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _connectionController = ConnectionController(navigatorKey: navigatorKey);
    _initPrefs();
    _loadScores();
    _aggiornaPokemon();
  }

  void _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _saveScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("CurrentScore", _score);
    await prefs.setInt("BestScore", _bestScore);
  }

  void _loadScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _score = prefs.getInt("CurrentScore") ?? 0;
      _bestScore = prefs.getInt("BestScore") ?? 0;
    });
  }

  void _aggiornaPokemon() async {
    _homeController.setListIds(_homeController.getRandomPokemonIds());
    setState(() {
      _playButtonPressed = false;
      _homeController.setPokemonDetails1(
          _homeController.fetchPokemonDetails(_homeController.getListIds()[0]));
      _homeController.setPokemonDetails2(
          _homeController.fetchPokemonDetails(_homeController.getListIds()[1]));
      _homeController.setPokemonDetails3(
          _homeController.fetchPokemonDetails(_homeController.getListIds()[2]));
      _homeController.setPokemonDetails4(
          _homeController.fetchPokemonDetails(_homeController.getListIds()[3]));
    });
  }

  void _aggiornaPunteggio(Future<int> selectedPokemonIndexFuture) {
    selectedPokemonIndexFuture.then((selectedPokemonIndex) {
      _indexCurrentPkmn.then((indexCurrentPkmn) {
        if (selectedPokemonIndex == indexCurrentPkmn) {
          setState(() {
            _score++;
            if (_score > _bestScore) {
              _bestScore = _score;
              _prefs.setInt("BestScore", _bestScore); //aggiorno il nuovo record
            }
            _aggiornaPokemon();
            _saveScores(); //meglio tener sempre aggiornati i punteggi
          });
        } else {
          setState(() {
            _score = 0;
            //prendo il valore dell'elemento in posizione 'vincente' della lista
            _mostraGameOverDialog(
                _homeController.getListIds()[indexCurrentPkmn]);
            _saveScores(); //meglio tener sempre aggiornati i punteggi
          });
        }
      });
    });
  }

  Future<void> _mostraGameOverDialog(int index) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
              child: Text(
            'Game Over',
            style: TextStyle(fontSize: 32),
          )),
          contentPadding:
              EdgeInsets.zero, // Rimuove il padding intorno al contenuto
          content: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              _aggiornaPokemon();
            },
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Imposta la dimensione minima del Column
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    _homeController.getPokemonSpriteUrl(index),
                    fit: BoxFit.contain, // Adatta l'immagine al box
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: const Icon(
                    Icons.refresh_outlined,
                    color: Color(0xFFD02525),
                    size: 50,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Pokecho",
        context: context,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _homeController.getPokemonDetails1(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    padding: const EdgeInsets.all(10),
                    children: List.generate(4, (index) {
                      Future<Map<String, dynamic>> pokemonDetails;
                      switch (index) {
                        case 0:
                          pokemonDetails = _homeController.getPokemonDetails1();
                          break;
                        case 1:
                          pokemonDetails = _homeController.getPokemonDetails2();
                          break;
                        case 2:
                          pokemonDetails = _homeController.getPokemonDetails3();
                          break;
                        case 3:
                          pokemonDetails = _homeController.getPokemonDetails4();
                          break;
                        default:
                          throw Exception("Invalid index");
                      }
                      return FutureBuilder(
                        future: pokemonDetails,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final pokemonData =
                                snapshot.data as Map<String, dynamic>;
                            final String spriteUrl = pokemonData['sprites']
                                ['other']['official-artwork']['front_default'];
                            return GestureDetector(
                              onTap: _playButtonPressed
                                  ? () {
                                      //se il pulsante 'Play' è stato premuto si può procedere col gioco
                                      _aggiornaPunteggio(Future.value(index));
                                    }
                                  : () {
                                      //altrimenti mostra un Toast
                                      Fluttertoast.showToast(
                                        msg: "Press 'Play' button",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                      );
                                    },
                              child: Image.network(
                                spriteUrl,
                                width: 100,
                                height: 100,
                              ),
                            );
                          }
                        },
                      );
                    }),
                  );
                }
              },
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Best Score: $_bestScore",
                  style: const TextStyle(fontSize: 34),
                ),
                Text(
                  "$_score",
                  style: const TextStyle(fontSize: 34),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(30),
                      child: ElevatedButton(
                        onPressed: () async {
                          int index = await _homeController.riproduciSuono();
                          setState(() {
                            _indexCurrentPkmn = Future.value(index);
                            _playButtonPressed = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFAF9F6),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(18),
                          shadowColor: const Color(0xFFD02525),
                        ),
                        child: const Icon(
                          Icons.play_arrow_outlined,
                          color: Color(0xFFD02525),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _homeController.getAudioPlayer().dispose();
    _saveScores(); //salvataggio dei punteggi prima di distruggere il widget
    super.dispose();
  }
}
