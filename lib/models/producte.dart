import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Producte {
  final String name;
  final String photo;

  Producte({required this.name, required this.photo});

  factory Producte.fromJson(Map<String, dynamic> json) {
    return Producte(
      name: json['nomProduit'].replaceAll('"', ''),
      photo: json['photoProduit'],
    );
  }

  // Static function to fetch all Productes
  static Future<List<Producte>> fetchProductes() async {
    final response = await http.get(Uri.parse(dotenv.env['GET_ALL_PRODUCTS_URL']!));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => Producte.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Productes');
    }
  }
}
