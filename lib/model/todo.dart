import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
// class ToDo {
  // String? id;
  // String? todoText;
  // bool isDone;
  // String? todoNote;
  // DateTime? date; 
  // TimeOfDay? time;

  // ToDo({
  //   required this.id,
  //   required this.todoText,
  //   this.isDone = false,
  //   this.todoNote,
  //   this.date,
  //   this.time,
  // });

  // static List<ToDo> todoList() {
  //   return [
  //     ToDo(
  //   id: '1',
  //   todoText: 'Buy groceries',
  //   todoNote: 'Need to buy milk, eggs, and bread.',
  //   date: DateTime(2025, 8, 11),
  //   time: const TimeOfDay(hour: 10, minute: 30),
  // ),
  // ToDo(
  //   id: '2',
  //   todoText: 'Call plumber',
  //   todoNote: 'Fix kitchen sink leakage.',
  //   date: DateTime(2025, 8, 12),
  //   time: const TimeOfDay(hour: 15, minute: 0),
  // ),
  // ToDo(
  //   id: '3',
  //   todoText: 'Finish Flutter project',
  //   todoNote: 'Add Hive database support for local storage.',
    
  // ),
  // ToDo(
  //   id: '4',
  //   todoText: 'Go for evening run',
  //   todoNote: '5 km in the park.',
  //   date: DateTime(2025, 8, 14),
  //   time: const TimeOfDay(hour: 18, minute: 30),
  // ),
  //   ];
  // }
  // }



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
  bool isDone= false;

  @HiveField(3)
  String? todoNote;

  @HiveField(4)
  DateTime? date;

  // Hive doesn't know TimeOfDay by default — we'll register a TimeOfDayAdapter.
  @HiveField(5)
  TimeOfDay? time;

}

