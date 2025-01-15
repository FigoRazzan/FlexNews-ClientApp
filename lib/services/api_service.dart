import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://api-berita-indonesia.vercel.app/';

  Future<List<dynamic>> fetchPublicData(
      {required String media, required String category}) async {
    final String apiUrl = '$baseUrl/$media/$category/';
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return json['data']['posts'];
    } else {
      throw Exception('Failed to load data');
    }
  }
}
