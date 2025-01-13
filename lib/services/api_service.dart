import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String publicApiUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<dynamic>> fetchPublicData() async {
    final response = await http.get(Uri.parse(publicApiUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
