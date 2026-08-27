import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_management/api/exception/unauthorized.dart';
import 'package:task_management/models/user_response.dart';
import 'package:task_management/token/token_storage.dart';

class ApiUpdateUser {
  final String baseUrl = 'http://10.0.2.2:5030/api';

  Future<UserModel> updateUser({
    required int userId,
    required String fullName,
    required String userName,
    required String emailAddress,
    required String password,
    String? jobTitle,
    String? timeZone,
    required String accountStatus,
    String? dateCreated,
    required String lastLoginDate,
    required String role,
  }) async {
    // Get access token from secure storage
    final String? accessToken = await TokenStorage.getAccessToken();

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('Access token not found');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/User/updateUserData/$userId'),

      // Send token with request
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },

      // Send user data
      body: jsonEncode({
        "user_id": userId,
        "full_name": fullName,
        "user_name": userName,
        "email_address": emailAddress,
        "password": password,
        "job_title": jobTitle,
        "time_zone": timeZone,
        "account_status": accountStatus,
        "date_created": dateCreated,
        "last_login_date": lastLoginDate,
        "user_role": role,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);

      return UserModel.fromJson(data);
    }

    if (response.statusCode == 401) {
      return throw const UnauthorizedException();
    }

    throw Exception(
      'Update task failed: '
      '${response.statusCode} ${response.body}',
    );
  }
}
