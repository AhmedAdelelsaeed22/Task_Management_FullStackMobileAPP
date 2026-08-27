import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_management/api/exception/unauthorized.dart';
import 'package:task_management/token/token_storage.dart';

class ApiCompleteTask {
  static const String baseUrl = "http://10.0.2.2:5030/api";

  Future<bool> completeTask(int taskId) async {
    final url = Uri.parse("$baseUrl/Task/CompletedTask/$taskId");

    final String? accessToken = await TokenStorage.getAccessToken();

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({'TaskId': taskId}),
    );

    if (response.statusCode != 200) {
      return false;
    }

    if (response.statusCode == 401) {
      return throw const UnauthorizedException();
    }

    return true;
  }
}
