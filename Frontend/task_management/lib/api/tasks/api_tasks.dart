import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_management/models/task_response.dart';
import 'package:task_management/token/token_storage.dart';

class TasksApi {
  static const String baseUrl = 'http://10.0.2.2:5030/api';

  Future<List<TaskModel>> getTasks(int userId) async {
    final token = await TokenStorage.getAccessToken();

    final response = await http.get(
      Uri.parse('$baseUrl/Task/GetAllTasksUsingUserId/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((json) => TaskModel.fromJson(json)).toList();
    }

    throw Exception('Failed to load tasks: ${response.statusCode}');
  }
}
