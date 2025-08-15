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

