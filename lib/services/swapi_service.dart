import 'dart:convert';
import 'package:flutter_application_1/widgets/character_card.dart';
import 'package:http/http.dart' as http;
import '../models/character_model.dart';

class SwapiService {
  final String baseUrl = 'https://swapi.dev/api/people/';

  Future<List<CharacterModel>> fetchCharacters() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List;

      return results.map((json) => CharacterModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener personajes');
    }
  }

  Future<List<CharacterModel>> buscarPersonajes(String query) async {
    final url = Uri.parse('https://swapi.dev/api/people/?search=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List;

      return results.map((json) => CharacterModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al buscar personajes');
    }
  }
}
