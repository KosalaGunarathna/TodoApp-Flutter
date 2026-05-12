import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/todo.dart';

class TodoService {
  final Box<ToDo> todoBox;

  TodoService(this.todoBox);

  List<ToDo> getAllTodos() {
    return todoBox.values.toList();
  }

  void addTodo(String todoText, String todoNote, DateTime? date, TimeOfDay? time) {
    if (todoText.isNotEmpty) {
      final newTodo = ToDo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        todoText: todoText,
        todoNote: todoNote,
        date: date,
        time: time,
      );
      todoBox.add(newTodo);
    }
  }

  void deleteTodo(String id) {
    final index = todoBox.values.toList().indexWhere((item) => item.id == id);
    if (index != -1) {
      todoBox.deleteAt(index);
    }
  }

  void updateTodo(String id, String updatedText, String updatedNote, DateTime? date, TimeOfDay? time) {
  final index = todoBox.values.toList().indexWhere((item) => item.id == id);
  if (index != -1) {
    final todo = todoBox.getAt(index);
    if (todo != null) {
      todo.todoText = updatedText;
      todo.todoNote = updatedNote;
      todo.date = date;
      todo.time = time; // works now
      todo.save();
    }
  }
}

  List<ToDo> searchTodos(String keyword) {
    if (keyword.isEmpty) return getAllTodos();
    return todoBox.values
        .where((item) => item.todoText!.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }
}