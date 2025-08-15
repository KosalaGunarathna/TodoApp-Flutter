import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todoapp/color_theam/color.dart';
import 'package:todoapp/screens/AddTodoPage.dart';
import '../widgets/todo_item.dart';
import '../model/todo.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Box<ToDo> todoBox;

  List<ToDo> _foundTodo = [];
  final _todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    todoBox = Hive.box<ToDo>('todos');
    _loadTodos();
  }

  void _loadTodos() {
    setState(() {
      _foundTodo = todoBox.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buidAppBar(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              children: [
                searchBox(),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 50),
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        child: const Text(
                          'All Todos',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      for (ToDo todoo in _foundTodo.reversed)
                        ToDoItem(
                          todo: todoo,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem: _handleDeleteItem,
                          onUpdateItem: _updateTodoItem,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          //addd new item

          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  // width: 60,  
                  height: 45,
                  margin: const EdgeInsets.only(bottom:40, right: 40),
                  // padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddTodoPage()),
                      ).then((value) {
                        print(value); // This will print the whole map

                        if (value != null && value is Map) {
                          _addToDoItem(value['todoText'], value['todoNote'],value['date'], value['time']);
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      alignment: Alignment.center,
                      textStyle: const TextStyle(fontSize: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    child: const Text(
                      'Add new todo',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _handleDeleteItem(String id) {
    final index = todoBox.values.toList().indexWhere((item) => item.id == id);
    if (index != -1) {
      todoBox.deleteAt(index);
      _loadTodos();
    }
  }

  void _searchTodo(String enterKeyword) {
    List<ToDo> results = [];
    if (enterKeyword.isEmpty) {
      results = _foundTodo;
    } else {
      results = _foundTodo
          .where((item) =>
              item.todoText!.toLowerCase().contains(enterKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundTodo = results;
    });
  }

  void _updateTodoItem(String updatedText, String updateNote,
      DateTime? updateDate, TimeOfDay? updateTime, String id) {
    setState(() {
      // final index = _.indexWhere((item) => item.id == id);
      final index = _foundTodo.indexWhere((item) => item.id == id);
      if (index != -1) {
        final todo = _foundTodo[index];
        todo.todoText = updatedText;
        todo.todoNote = updateNote;
        todo.date = updateDate;
        todo.time = updateTime;
        todo.save();
        _loadTodos();
      }
    });
  }

  void _addToDoItem(String todo, String todoNote, DateTime? date, TimeOfDay? time) {
    if (todo.isNotEmpty) {
      setState(() {
        final newTodo = ToDo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          todoText: todo,
          todoNote: todoNote,
          date: date,
          time: time,
        );
        todoBox.add(newTodo); // save to Hive
        _loadTodos(); // refresh list
        _todoController.clear();
      });
    }
  }

  Widget searchBox() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color:
            Colors.grey.withOpacity(0.5), // shadow color with transparency
            spreadRadius: 2, // shadow size expansion
            blurRadius: 7, // blur effect
            offset: const Offset(0, 3), // shadow position (x, y)
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: tdBlack),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: (value) => _searchTodo(value),
              decoration: const InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buidAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.menu,
            color: tdBlack,
            size: 30,
          ),
          const Text(
            'Todo List',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
            width: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/profile.jpg'),
            ),
          ),
        ],
      ),
    );
  }
}
