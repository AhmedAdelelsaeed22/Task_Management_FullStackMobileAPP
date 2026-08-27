import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_management/token/token_storage.dart';

class ApiRefreshToken {
  final String baseUrl = 'http://10.0.2.2:5030/api';

  Future<void> refreshToken(String email) async {
    // Get the old refresh token from secure storage
    final String? oldRefreshToken = await TokenStorage.getRefreshToken();

    if (oldRefreshToken == null || oldRefreshToken.isEmpty) {
      throw Exception('Refresh token not found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/Auth/refresh'),

      headers: {'Content-Type': 'application/json'},

      body: jsonEncode({'refreshToken': oldRefreshToken, 'email': email}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Get new tokens from backend
      final String newAccessToken = data['access_token'];

      final String newRefreshToken = data['refresh_token'];

      // Replace old tokens with new tokens
      await TokenStorage.saveTokens(newAccessToken, newRefreshToken);
    }

    throw Exception(
      'Refresh token failed: '
      '${response.statusCode} ${response.body}',
    );
  }
}
