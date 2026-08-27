import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_management/models/login_response.dart';
import 'package:task_management/token/token_storage.dart';

class ApiLogin {
  static const String baseUrl = "http://10.0.2.2:5030/api";

  Future<bool> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/Auth/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"emailAddress": email, "password": password}),
    );

    if (response.statusCode != 200) {
      return false;
    }

    final login = LoginResponse.fromJson(jsonDecode(response.body));

    await TokenStorage.saveTokens(login.accessToken, login.refreshToken);
    return true;
  }
}
