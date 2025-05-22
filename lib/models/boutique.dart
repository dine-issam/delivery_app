import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Boutique {
  final String name;
  final String photo;

  Boutique({required this.name, required this.photo});

  factory Boutique.fromJson(Map<String, dynamic> json) {
    return Boutique(
      name: json['nomBoutique'].replaceAll('"', ''),
      photo: json['photo'],
    );
  }

  // Static function to fetch all boutiques
  static Future<List<Boutique>> fetchBoutiques() async {
    final response = await http.get(Uri.parse(dotenv.env['GET_ALL_BOUTIQUES_URL']!));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => Boutique.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load boutiques');
    }
  }
}
