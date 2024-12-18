import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo_model.dart';

class ApiService {
  final String baseUrl = "http://192.168.1.4/api/index.php";

  // Mengambil data To-Do List (GET)
  Future<List<Todo>> getTodos() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Todo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load todos');
      }
    } catch (e) {
      throw Exception('Failed to load todos: $e');
    }
  }

  // Menambahkan To-Do List (POST)
  Future<void> addTodo(String title) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"title": title}), // Kirim data sebagai JSON
      );

      // Debugging: Print status dan response dari server
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception('Failed to add task: ${response.body}');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Failed to add task: $e');
    }
  }

  // Memperbarui status To-Do List (PUT)
  Future<void> updateTodoStatus(int id, bool isCompleted) async {
    try {
      final response = await http.put(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": id,
          "is_completed": isCompleted ? 1 : 0,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update task status');
      }
    } catch (e) {
      throw Exception('Failed to update task status: $e');
    }
  }

  // Menghapus To-Do List (DELETE)
  Future<void> deleteTodo(int id) async {
    try {
      final response = await http.delete(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": id}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete task');
      }
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }
}
