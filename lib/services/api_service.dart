import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String publicApiUrl =
      'https://api-berita-indonesia.vercel.app/antara/terbaru/';

  Future<List<dynamic>> fetchPublicData() async {
    final response = await http.get(Uri.parse(publicApiUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      // Ambil data dari properti 'posts'
      return json['data']['posts'];
    } else {
      throw Exception('Failed to load data');
    }
  }
}
