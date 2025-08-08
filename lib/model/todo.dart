import 'dart:async';

class ToDo {
  String? id;
  String? todoText;
  bool isDone;
  Timer? time;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
    this.time,
  });


  static List<ToDo> todoList() {
    return [
    
      ToDo(id: '02', todoText: 'hellow 02',isDone: true),
      ToDo(id: '03', todoText: 'hellow 03'),
      ToDo(id: '04', todoText: 'hellow 04'),
      ToDo(id: '05', todoText: 'hellow 05'),
      ToDo(id: '06', todoText: 'hellow 06'),
      ToDo(id: '07', todoText: 'hellow 07',time: Timer(Duration(seconds: 5), () {
        print('Timer for todo 07 completed');
      })),
    ];
  }
}
