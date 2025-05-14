import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../model/task_model.dart';

class TaskRemoteDataSource {
  final String apiUrl = 'https://68243c0d65ba0580339963f8.mockapi.io/task_app';

  // Fetch tasks from remote API
  Future<List<Task>> getTasksFromApi() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((task) => Task.fromJson(task)).toList();
    } else {
      throw Exception('Failed to load tasks from API');
    }
  }

  // Create a new task via API
  Future<Task> createTaskOnApi(Task task) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );

    if (response.statusCode == 201) {
      return Task.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to create task');
    }
  }

  // Update a task via API
  Future<Task> updateTaskOnApi(Task task) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${task.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );

    if (response.statusCode == 200) {
      return Task.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to update task');
    }
  }

  // Delete a task via API
  Future<void> deleteTaskFromApi(String taskId) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/$taskId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }
}
