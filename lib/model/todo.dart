import 'dart:async';

class ToDo {
  String? id;
  String? todoText;
  bool isDone;
  String? todoNote;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
    this.todoNote='',
    
  });

  static List<ToDo> todoList() {
    return [
      ToDo(id: '02', todoText: 'hellow 02', isDone: true),
      ToDo(id: '03', todoText: 'hellow 03'),
      ToDo(id: '04', todoText: 'hellow 04'),
      ToDo(id: '05', todoText: 'hellow 05'),
      ToDo(id: '06', todoText: 'hellow 06',todoNote: 'This is a note for todo 06'),
    ];
  }
}
