import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:pokecho/utils/custom_appbar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Random _random = Random();
  late Future<Map<String, dynamic>> _pokemonDetails1;
  late Future<Map<String, dynamic>> _pokemonDetails2;
  late Future<Map<String, dynamic>> _pokemonDetails3;
  late Future<Map<String, dynamic>> _pokemonDetails4;
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _getRandomId() {
    return _random.nextInt(700);
  }

  Future<Map<String, dynamic>> _fetchPokemonDetails(int id) async {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load Pokemon details');
    }
  }

  Future<void> _aggiornaPokemon() async {
    List<int> pokemonIds = [];
    for (int i = 0; i < 4; i++) {
      pokemonIds.add(_getRandomId());
    }
    setState(() {
      _pokemonDetails1 = _fetchPokemonDetails(pokemonIds[0]);
      _pokemonDetails2 = _fetchPokemonDetails(pokemonIds[1]);
      _pokemonDetails3 = _fetchPokemonDetails(pokemonIds[2]);
      _pokemonDetails4 = _fetchPokemonDetails(pokemonIds[3]);
    });
  }

  @override
  void initState() {
    super.initState();
    _aggiornaPokemon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Home"),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              padding: EdgeInsets.all(10),
              children: [
                _buildPokemonImage(_pokemonDetails1),
                _buildPokemonImage(_pokemonDetails2),
                _buildPokemonImage(_pokemonDetails3),
                _buildPokemonImage(_pokemonDetails4),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _aggiornaPokemon,
            child: Text("Aggiorna"),
          ),
          ElevatedButton(
            onPressed: _riproduciSuono,
            child: Text("Riproduci Suono"),
          ),
        ],
      ),
    );
  }

  Widget _buildPokemonImage(Future<Map<String, dynamic>> pokemonDetails) {
    return FutureBuilder(
      future: pokemonDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final pokemonData = snapshot.data as Map<String, dynamic>;
          final String spriteUrl = pokemonData['sprites']['front_default'];
          return Image.network(
            spriteUrl,
            width: 100,
            height: 100,
          );
        }
      },
    );
  }

  Future<void> _riproduciSuono() async {
    List<Future<Map<String, dynamic>>> pokemonDetails = [
      _pokemonDetails1,
      _pokemonDetails2,
      _pokemonDetails3,
      _pokemonDetails4,
    ];
    int randomIndex = _random.nextInt(4);
    print("\n\n\nPosizione del pokemon da indovinare: $randomIndex");
    Map<String, dynamic> pokemonData = await pokemonDetails[randomIndex];
    String? versoUrl = pokemonData['cries']['legacy'];
    if (versoUrl != null) {
      _audioPlayer.play(UrlSource(versoUrl));
    } else {
      print("URL del verso non disponibile");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
