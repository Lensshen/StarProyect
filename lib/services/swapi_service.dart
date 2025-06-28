import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SwapiService {
  
  final String baseUrl = 'https://swapi.info/api/people';

  Future<List<CharacterModel>> buscarPersonajes(String query) async {
    final rawUrl = 'https://swapi.info/api/people/?search=$query';

    final uri =
        kIsWeb
            ? Uri.parse('https://api.allorigins.win/raw?url=$rawUrl')
            : Uri.parse(rawUrl);

    print(' Llamando a: $uri');

    final response = await http.get(uri);
    print(' Respuesta: ${response.body.substring(0, 200)}...');

    if (response.statusCode != 200) {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (e) {
      print(' Error JSON decode: $e');
      throw Exception('Respuesta no es JSON válido');
    }

    if (decoded is List) {
      return decoded.map((json) => CharacterModel.fromJson(json)).toList();
    } else {
      print(' Se esperaba una lista pero llegó: ${decoded.runtimeType}');
      throw Exception('La API devolvió un formato inesperado');
    }
  }
}
