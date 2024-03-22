import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeController {
  var generator = Random();
  late Future<Map<String, dynamic>> _pokemonDetails1;
  late Future<Map<String, dynamic>> _pokemonDetails2;
  late Future<Map<String, dynamic>> _pokemonDetails3;
  late Future<Map<String, dynamic>> _pokemonDetails4;
  List<int> _pokemonIds = [];
  final AudioPlayer _audioPlayer = AudioPlayer();

  //costruttore
  HomeController() {
    _pokemonDetails1 = Future.value({});
    _pokemonDetails2 = Future.value({});
    _pokemonDetails3 = Future.value({});
    _pokemonDetails4 = Future.value({});
  }

  //getter e setter
  Future<Map<String, dynamic>> getPokemonDetails1() {
    return _pokemonDetails1;
  }

  void setPokemonDetails1(Future<Map<String, dynamic>> pkmnDetails1) {
    _pokemonDetails1 = pkmnDetails1;
  }

  Future<Map<String, dynamic>> getPokemonDetails2() {
    return _pokemonDetails2;
  }

  void setPokemonDetails2(Future<Map<String, dynamic>> pkmnDetails2) {
    _pokemonDetails2 = pkmnDetails2;
  }

  Future<Map<String, dynamic>> getPokemonDetails3() {
    return _pokemonDetails3;
  }

  void setPokemonDetails3(Future<Map<String, dynamic>> pkmnDetails3) {
    _pokemonDetails3 = pkmnDetails3;
  }

  Future<Map<String, dynamic>> getPokemonDetails4() {
    return _pokemonDetails4;
  }

  void setPokemonDetails4(Future<Map<String, dynamic>> pkmnDetails4) {
    _pokemonDetails4 = pkmnDetails4;
  }

  AudioPlayer getAudioPlayer() {
    return _audioPlayer;
  }

  //altri metodi
  List<int> getListIds() {
    return _pokemonIds;
  }

  void setListIds(List<int> lista) {
    _pokemonIds = lista;
  }

  int getRandomId() {
    int randomId = generator.nextInt(1026);

    return randomId;
  }

  //effettua una richiesta a pokeapi e ottiene il body
  Future<Map<String, dynamic>> fetchPokemonDetails(int id) async {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load Pokemon details');
    }
  }

  //aggiunge 4 numeri randomici ad una lista vuota
  List<int> getRandomPokemonIds() {
    List<int> lista = [];

    for (int i = 0; i < 4; i++) {
      lista.add(getRandomId());
    }
    return lista;
  }

  //da una lista vuota ritorna un elemento in posizione da 0-3
  int scegliPokemon(List<int> lista) {
    int scelto = generator.nextInt(3);

    return lista.elementAt(scelto);
  }

  Future<int> riproduciSuono() async {
    List<Future<Map<String, dynamic>>> pokemonDetails = [
      _pokemonDetails1,
      _pokemonDetails2,
      _pokemonDetails3,
      _pokemonDetails4,
    ];

    int idPkmn = scegliPokemon(_pokemonIds);
    print("ID -> $idPkmn");
    int randomIndex = _pokemonIds.indexOf(idPkmn);
    print("Posizione del pokemon da indovinare: $randomIndex\n\n\n");
    Map<String, dynamic> pokemonData = await pokemonDetails[
        randomIndex]; //accedo al body del pokemon con posizione nella UI che funge da chiave dell'array
    String? versoUrl = pokemonData['cries']['latest'];
    if (versoUrl != null) {
      _audioPlayer.play(UrlSource(versoUrl));
    } else {
      print("URL del verso non disponibile");
    }
    return randomIndex;
  }
}
