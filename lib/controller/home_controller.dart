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
}
