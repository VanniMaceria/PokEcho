import 'package:pokecho/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:pokecho/utils/custom_appbar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeController _homeController = HomeController();
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _aggiornaPokemon();
  }

  Future<void> _aggiornaPokemon() async {
    _homeController.setListIds(_homeController
        .getRandomPokemonIds()); // Ottengo 4 id casuali di pokemon
    setState(() {
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

  void aggiornaPunteggio() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Home"),
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                        onPressed: _aggiornaPokemon,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFAF9F6),
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(18),
                            shadowColor: const Color(0xFFD02525)),
                        child: const Icon(
                          Icons.refresh_outlined,
                          color: Color(0xFFD02525),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(30),
                      child: ElevatedButton(
                        onPressed: () {
                          _homeController.riproduciSuono();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFAF9F6),
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(18),
                            shadowColor: const Color(0xFFD02525)),
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
    super.dispose();
  }
}
