import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();
  List<Todo> todos = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    final data = await apiService.getTodos();
    setState(() {
      todos = data;
    });
  }

  void addTodo() async {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a task')),
      );
      return;
    }

    try {
      setState(() {
        // Show loading indicator
        todos = [
          ...todos,
          Todo(id: -1, title: _controller.text, isCompleted: false)
        ];
      });

      await apiService.addTodo(_controller.text);
      _controller.clear();
      await fetchTodos(); // Refresh the list

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task added successfully')),
      );
    } catch (e) {
      setState(() {
        // Remove temporary todo if error occurs
        todos.removeLast();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add task: ${e.toString()}')),
      );
    }
  }

  void toggleTodoStatus(Todo todo) async {
    await apiService.updateTodoStatus(todo.id, !todo.isCompleted);
    fetchTodos();
  }

  void deleteTodo(int id) async {
    await apiService.deleteTodo(id);
    fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To-Do List"),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Enter a task",
                    ),
                    onSubmitted: (_) => addTodo(), // Add task on Enter key
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: addTodo,
                  color: Colors.teal, // Make button more visible
                  tooltip: 'Add Task', // Add tooltip for better UX
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  leading: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (_) => toggleTodoStatus(todo),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteTodo(todo.id),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
