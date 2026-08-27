import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task_management/api/exception/unauthorized.dart';
import 'package:task_management/models/user_response.dart';
import 'package:task_management/token/token_storage.dart';

class GetUserDataApi {
  static const String baseUrl = 'http://10.0.2.2:5030/api';

  Future<UserModel> getUserData(int userId) async {
    final token = await TokenStorage.getAccessToken();

    if (token == null || token.isEmpty) {
      throw Exception('Access token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/User/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      return UserModel.fromJson(data);
    }

    if (response.statusCode == 401) {
      return throw const UnauthorizedException();
    }

    throw Exception('Failed to load user data: ${response.statusCode}');
  }
}
