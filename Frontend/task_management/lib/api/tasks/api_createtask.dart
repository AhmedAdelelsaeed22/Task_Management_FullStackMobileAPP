import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_management/api/exception/unauthorized.dart';
import 'package:task_management/models/task_response.dart';
import 'package:task_management/token/token_storage.dart';

class ApiCreateTask {
  final String baseUrl = 'http://10.0.2.2:5030/api';

  Future<TaskModel> createTask({
    required int userId,
    required int statusId,
    required int priorityId,
    required String title,
    String? description,
    double? estimateHours,
    required String creationDate,
    String? lastUpdateDate,
    String? completionDate,
  }) async {
    // Get access token from secure storage
    final String? accessToken = await TokenStorage.getAccessToken();

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('Access token not found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/Task/InsertNewTask'),

      // Send token with request
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },

      // Send task data
      body: jsonEncode({
        'user_id': userId,
        'status_id': statusId,
        'priority_id': priorityId,
        'title': title,
        'description': description,
        'estimate_hours': estimateHours,
        'creation_date': creationDate,
        'last_update_date': lastUpdateDate,
        'completion_date': completionDate,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);

      return TaskModel.fromJson(data);
    }

    if (response.statusCode == 401) {
      return throw const UnauthorizedException();
    }

    throw Exception(
      'Create task failed: '
      '${response.statusCode} ${response.body}',
    );
  }
}
