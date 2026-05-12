import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/model/todo.dart';

class TodoRepository {
  static const String _boxName = 'todos';

  // Get all todos
  Future<List<ToDo>> getAllTodos() async {
    final box = await Hive.openBox<ToDo>(_boxName);
    return box.values.toList();
  }

  // Print all todos (for debugging)
  Future<void> printAllTodos() async {
    final todos = await getAllTodos();

    if (todos.isEmpty) {
      print('No todos found.');
      return;
    }

    for (var todo in todos) {
      print('ID: ${todo.id}');
      print('Text: ${todo.todoText}');
      print('Done: ${todo.isDone}');
      print('Note: ${todo.todoNote}');
      print('Date: ${todo.date}');
      print('Time: ${todo.time}');
      print('---');
    }
  }
}