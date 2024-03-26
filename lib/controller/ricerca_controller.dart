import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

class RicercaController {
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayer getAudioPlayer() {
    return _audioPlayer;
  }

  //qui si effettua una richiesta dove il parametro può essere sia il nome che l'id numerico
  Future<Map<String, dynamic>> fetchPokemonDetails(var filtro) async {
    //easter egg stupido :)
    if (filtro == "developer") {
      filtro = "monferno";
    }

    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$filtro'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load Pokemon details');
    }
  }

  void riproduciVerso(var json) {
    String? versoUrl = json['cries']['latest'];

    if (versoUrl != null) {
      _audioPlayer.play(UrlSource(versoUrl));
    } else {
      print("URL del verso non disponibile");
    }
  }
}
