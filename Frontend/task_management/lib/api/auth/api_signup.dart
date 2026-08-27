import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiSignup {
  static const String baseUrl = "http://10.0.2.2:5030/api";

  Future<bool> signUp({
    required String fullName,
    required String userName,
    required String email,
    required String password,
    required String jobTitle,
  }) async {
    final url = Uri.parse("$baseUrl/Auth/SignUp");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "full_name": fullName,
        "user_name": userName,
        "email_address": email,
        "password": password,
        "job_title": jobTitle,
      }),
    );

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    }

    return false;
  }
}
