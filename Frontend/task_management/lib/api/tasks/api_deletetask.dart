import 'package:http/http.dart' as http;
import 'package:task_management/api/exception/unauthorized.dart';
import 'package:task_management/token/token_storage.dart';

class ApiDeleteTask {
  final String baseUrl = 'http://10.0.2.2:5030/api';

  // ==========================================================
  // FIND TASK BY ID
  // ==========================================================

  Future<bool> deleteTask(int taskId) async {
    // --------------------------------------------------------
    // GET ACCESS TOKEN
    // --------------------------------------------------------

    final String? accessToken = await TokenStorage.getAccessToken();

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('Access token not found');
    }

    // --------------------------------------------------------
    // SEND REQUEST
    // --------------------------------------------------------

    final response = await http.delete(
      Uri.parse('$baseUrl/Task/DeleteTask/$taskId'),

      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    // --------------------------------------------------------
    // SUCCESS
    // --------------------------------------------------------

    if (response.statusCode == 200) {
      return true;
    }

    // --------------------------------------------------------
    // UNAUTHORIZED
    // --------------------------------------------------------

    if (response.statusCode == 401) {
      throw const UnauthorizedException();
    }

    // --------------------------------------------------------
    // NOT FOUND
    // --------------------------------------------------------

    if (response.statusCode == 404) {
      throw Exception('Task not found');
    }

    // --------------------------------------------------------
    // OTHER ERRORS
    // --------------------------------------------------------

    throw Exception(
      'Delete task failed: '
      '${response.statusCode} ${response.body}',
    );
  }
}
