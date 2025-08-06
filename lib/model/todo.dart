class ToDo {
  String? id;
  String? todoText;
  bool isDone;

  ToDo({required this.id, required this.todoText, this.isDone = false});

  static List<ToDo> todoList() {
    return [
      ToDo(id: '01', todoText: 'hellow 01',isDone: true),
      ToDo(id: '02', todoText: 'hellow 02',isDone: true),
      ToDo(id: '03', todoText: 'hellow 03'),
      ToDo(id: '04', todoText: 'hellow 04'),
      ToDo(id: '05', todoText: 'hellow 05'),
    ];
  }
}
