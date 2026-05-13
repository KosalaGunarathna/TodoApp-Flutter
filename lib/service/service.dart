import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/service/notification_service.dart';
import '../model/todo.dart';

class TodoService {
  final Box<ToDo> todoBox;

  TodoService(this.todoBox);

  List<ToDo> getAllTodos() {
    return todoBox.values.toList();
  }

void addTodo(String todoText, String todoNote, DateTime? date, TimeOfDay? time) async {
  if (todoText.isNotEmpty) {

    final newTodo = ToDo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      todoText: todoText,
      todoNote: todoNote,
      date: date,
      time: time,
    );

    final box = Hive.box<ToDo>('todos');
    box.add(newTodo);

    // 🔥 AUTO SCHEDULE NOTIFICATION HERE
    await NotificationService.scheduleTodo(newTodo);
  }
}

  void deleteTodo(String id) {
    final index = todoBox.values.toList().indexWhere((item) => item.id == id);
    if (index != -1) {
      todoBox.deleteAt(index);
    }
  }

  void updateTodo(
  String id,
  String updatedText,
  String updatedNote,
  DateTime? date,
  TimeOfDay? time,
) async {

  final index = todoBox.values.toList().indexWhere((item) => item.id == id);

  if (index != -1) {
    final todo = todoBox.getAt(index);

    if (todo != null) {

      // Cancel old notification
      await NotificationService.cancelNotification(todo.id.hashCode);

      // Update values
      todo.todoText = updatedText;
      todo.todoNote = updatedNote;
      todo.date = date;
      todo.time = time;

      await todo.save();

      // Schedule new notification
      await NotificationService.scheduleTodo(todo);
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