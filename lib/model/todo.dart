import 'package:flutter/material.dart';

class ToDo {
  String? id;
  String? todoText;
  bool isDone;
  String? todoNote;
  DateTime? date; 
  TimeOfDay? time;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
    this.todoNote = '',
    this.date,
    this.time,
  });

  static List<ToDo> todoList() {
    return [
      ToDo(id: '02', todoText: 'hellow 02', isDone: true),
      ToDo(id: '03', todoText: 'hellow 03'),
      ToDo(id: '04', todoText: 'hellow 04'),
      ToDo(id: '05', todoText: 'hellow 05'),
      ToDo(
          id: '06',
          todoText: 'hellow 06',
          todoNote: 'This is a note for todo 06',
          date : DateTime(2020,10,05),
          time: const TimeOfDay(hour: 10, minute: 30),
      ),
    ];
  }
}

