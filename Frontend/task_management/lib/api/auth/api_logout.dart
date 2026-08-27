import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:task_management/token/token_storage.dart';

class ApiLogout {
  static const String baseUrl = 'http://10.0.2.2:5030/api';

  static Future<bool> logout({
    required String email,
    required String refreshToken,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/Auth/logout');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        await TokenStorage.clear();

        return true;
      }

      debugPrint('Logout failed: ${response.statusCode}');

      debugPrint('Response: ${response.body}');

      return false;
    } catch (e) {
      debugPrint('Logout error: $e');

      return false;
    }
  }
}
