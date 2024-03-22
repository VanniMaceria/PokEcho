import 'dart:convert';
import 'package:http/http.dart' as http;

class RicercaController {
  //qui si effettua una richiesta dove il parametro può essere sia il nome che l'id numerico
  Future<Map<String, dynamic>> fetchPokemonDetails(var filtro) async {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$filtro'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load Pokemon details');
    }
  }
}
