import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeController {
  var generator = Random();
  HomeController();

  int getRandomId() {
    int randomId = generator.nextInt(700);

    return randomId;
  }

  Future<Map<String, dynamic>> fetchPokemonDetails(int id) async {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load Pokemon details');
    }
  }

  List<int> getRandomPokemonIds() {
    List<int> lista = [];

    for (int i = 0; i < 4; i++) {
      lista.add(getRandomId());
    }
    return lista;
  }

  int scegliPokemon(List<int> lista) {
    int scelto = generator.nextInt(3);

    return lista.elementAt(scelto);
  }
}
