import 'package:pokecho/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pokecho/utils/custom_appbar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeController _homeController = HomeController();
  late Future<Map<String, dynamic>> _pokemonDetails1;
  late Future<Map<String, dynamic>> _pokemonDetails2;
  late Future<Map<String, dynamic>> _pokemonDetails3;
  late Future<Map<String, dynamic>> _pokemonDetails4;
  List<int> _pokemonIds = [];
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _aggiornaPokemon();
  }

  Future<void> _aggiornaPokemon() async {
    _pokemonIds =
        _homeController.getRandomPokemonIds(); //ottengo 4 id casuali di pokemon
    setState(() {
      _pokemonDetails1 = _homeController.fetchPokemonDetails(_pokemonIds[0]);
      _pokemonDetails2 = _homeController.fetchPokemonDetails(_pokemonIds[1]);
      _pokemonDetails3 = _homeController.fetchPokemonDetails(_pokemonIds[2]);
      _pokemonDetails4 = _homeController.fetchPokemonDetails(_pokemonIds[3]);
    });
  }

  Future<void> _riproduciSuono() async {
    List<Future<Map<String, dynamic>>> pokemonDetails = [
      _pokemonDetails1,
      _pokemonDetails2,
      _pokemonDetails3,
      _pokemonDetails4,
    ];

    int idPkmn = _homeController.scegliPokemon(_pokemonIds);
    print("ID -> $idPkmn");
    int randomIndex = _pokemonIds.indexOf(idPkmn);
    print("\n\n\nPosizione del pokemon da indovinare: $randomIndex");
    Map<String, dynamic> pokemonData = await pokemonDetails[
        randomIndex]; //accedo al body del pokemon con posizione nella UI che funge da chiave dell'array
    String? versoUrl = pokemonData['cries']['legacy'];
    if (versoUrl != null) {
      _audioPlayer.play(UrlSource(versoUrl));
    } else {
      print("URL del verso non disponibile");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Home"),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _pokemonDetails1,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  final pokemonData = snapshot.data as Map<String, dynamic>;
                  final String spriteUrl =
                      pokemonData['sprites']['front_default'];
                  return GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    padding: EdgeInsets.all(10),
                    children: List.generate(4, (index) {
                      Future<Map<String, dynamic>> pokemonDetails;
                      switch (index) {
                        case 0:
                          pokemonDetails = _pokemonDetails1;
                          break;
                        case 1:
                          pokemonDetails = _pokemonDetails2;
                          break;
                        case 2:
                          pokemonDetails = _pokemonDetails3;
                          break;
                        case 3:
                          pokemonDetails = _pokemonDetails4;
                          break;
                        default:
                          throw Exception("Invalid index");
                      }
                      return FutureBuilder(
                        future: pokemonDetails,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final pokemonData =
                                snapshot.data as Map<String, dynamic>;
                            final String spriteUrl =
                                pokemonData['sprites']['front_default'];
                            return Image.network(
                              spriteUrl,
                              width: 100,
                              height: 100,
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
          ElevatedButton(
            onPressed: _aggiornaPokemon,
            child: Text("Aggiorna"),
          ),
          ElevatedButton(onPressed: _riproduciSuono, child: Text("Play"))
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
