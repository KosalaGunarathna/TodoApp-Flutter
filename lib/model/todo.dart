import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class ToDo extends HiveObject {
  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
    this.todoNote,
    this.date,
    this.time,
  });
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? todoText;

  @HiveField(2)
  bool isDone = false;

  @HiveField(3)
  String? todoNote;

  @HiveField(4)
  DateTime? date;

  @HiveField(5)
  TimeOfDay? time;
}

List<ToDo> exampleTodos = [
  ToDo(
    id: "1",
    todoText: "Buy groceries",
    isDone: false,
    todoNote: "Remember to buy milk and eggs",
    date: DateTime.now(),
    time: TimeOfDay(hour: 10, minute: 30),
  ),
  ToDo(
    id: "2",
    todoText: "Call mom",
    isDone: false,
    todoNote: "Her birthday today 🎂",
    date: DateTime.now(),
    time: TimeOfDay(hour: 15, minute: 0),
  ),
  ToDo(
    id: "3",
    todoText: "Finish Flutter project",
    isDone: false,
    todoNote: "Due next week",
    date: DateTime.now().add(Duration(days: 2)),
    time: TimeOfDay(hour: 18, minute: 45),
  ),
];
