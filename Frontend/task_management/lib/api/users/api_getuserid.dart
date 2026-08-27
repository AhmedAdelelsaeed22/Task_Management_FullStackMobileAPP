import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_management/token/token_storage.dart';

class GetUserIdUsingEmail {
  static const String baseUrl = 'http://10.0.2.2:5030/api';

  Future<int> getUserId(String Email) async {
    final token = await TokenStorage.getAccessToken();

    final response = await http.get(
      Uri.parse('$baseUrl/User/GetUserId/$Email'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      print(response.statusCode);
    }

    final data = jsonDecode(response.body);
    return data;
  }
}
