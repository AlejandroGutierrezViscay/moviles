import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/chuck_norris_joke.dart';

class ChuckNorrisService {
  static const String baseUrl = 'https://api.chucknorris.io/jokes';

  // Obtener un chiste aleatorio
  static Future<ChuckNorrisJoke> getRandomJoke() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/random'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return ChuckNorrisJoke.fromJson(data);
      } else {
        throw Exception(
          'Error al obtener chiste aleatorio: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener un chiste aleatorio de una categoría específica
  static Future<ChuckNorrisJoke> getRandomJokeByCategory(
    String category,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/random?category=$category'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return ChuckNorrisJoke.fromJson(data);
      } else {
        throw Exception(
          'Error al obtener chiste por categoría: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener todas las categorías disponibles
  static Future<List<String>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((category) => category.toString()).toList();
      } else {
        throw Exception('Error al obtener categorías: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Buscar chistes por texto
  static Future<List<ChuckNorrisJoke>> searchJokes(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search?query=$query'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> result = data['result'] ?? [];
        return result.map((joke) => ChuckNorrisJoke.fromJson(joke)).toList();
      } else {
        throw Exception('Error al buscar chistes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Generar una lista mixta de chistes (aleatorios y por categorías)
  static Future<List<ChuckNorrisJoke>> getMixedJokes() async {
    try {
      List<ChuckNorrisJoke> jokes = [];

      // Obtener categorías
      final categories = await getCategories();

      // Añadir algunos chistes aleatorios
      for (int i = 0; i < 3; i++) {
        final randomJoke = await getRandomJoke();
        jokes.add(randomJoke);
      }

      // Añadir chistes de diferentes categorías
      for (String category in categories.take(5)) {
        try {
          final categoryJoke = await getRandomJokeByCategory(category);
          jokes.add(categoryJoke);
        } catch (e) {
          // Si falla una categoría, continuar con las demás
          debugPrint('Error con categoría $category: $e');
        }
      }

      return jokes;
    } catch (e) {
      throw Exception('Error al obtener chistes mixtos: $e');
    }
  }
}
