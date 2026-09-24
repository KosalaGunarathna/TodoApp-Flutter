
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/models/todo.dart';
import 'package:todoapp/services/notification_service.dart';

class TodoService {
  final Box<ToDo> todoBox;

  TodoService(this.todoBox);

  List<ToDo> getAllTodos() {
    return todoBox.values.toList();
  }

  Future<void> addTodo(
    String todoText,
    String todoNote,
    DateTime? date,
    TimeOfDay? time,
  ) async {
    if (todoText.isNotEmpty) {
      final newTodo = ToDo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        todoText: todoText,
        todoNote: todoNote,
        date: date,
        time: time,
      );

      // Persist with the ID as the key.
      await todoBox.put(newTodo.id, newTodo);

      // Debug log.
      try {
        debugPrint('Todo added: id=${newTodo.id}, boxLength=${todoBox.length}');
      } catch (_) {}

      // Schedule notification.
      await NotificationService.scheduleTodo(newTodo);
    }
  }

  Future<void> deleteTodo(String id) async {
    // Delete by key to match put/get usage.
    await todoBox.delete(id);
    await NotificationService.cancelNotification(id);
  }

  Future<void> updateTodo(
    String id,
    String updatedText,
    String updatedNote,
    DateTime? date,
    TimeOfDay? time,
  ) async {
    final todo = todoBox.get(id);
    if (todo == null) return;

    // Cancel the old notification.
    await NotificationService.cancelNotification(id);

    // Update fields.
    todo.todoText = updatedText;
    todo.todoNote = updatedNote;
    todo.date = date;
    todo.time = time;

    // Persist the updated todo.
    await todoBox.put(id, todo);

    // Schedule the new notification.
    await NotificationService.scheduleTodo(todo);
  }

  List<ToDo> searchTodos(String keyword) {
    if (keyword.isEmpty) return getAllTodos();
    return todoBox.values
        .where(
          (item) =>
              item.todoText!.toLowerCase().contains(keyword.toLowerCase()),
        )
        .toList();
  }

  Future<void> deleteAllTodos() async {
    await NotificationService.plugin.cancelAll(); // Cancel all notifications.
    await todoBox.clear(); // Delete all todos from Hive.
  }
}
