import 'package:flutter/material.dart';
import 'package:todoapp/color_theam/color.dart';
import 'package:todoapp/screens/AddTodoPage.dart';
import '../widgets/todo_item.dart';
import '../model/todo.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todoList = ToDo.todoList();
  List<ToDo> _foundTodo = [];
  final _todoController = TextEditingController();

  @override
  void initState() {
    _foundTodo = todoList;
    super.initState();
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
                          'All ToDos',
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
                // Expanded(
                //   child: Container(
                //     margin:
                //         const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                //     padding: EdgeInsets.symmetric(horizontal: 10),
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       boxShadow: const [
                //         BoxShadow(
                //             color: Colors.grey,
                //             offset: Offset(0.0, 0.0),
                //             blurRadius: 10.0,
                //             spreadRadius: 0.0),
                //       ],
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //     child: TextField(
                //       controller: _todoController,
                //       decoration: const InputDecoration(
                //         hintText: 'Add a new todo item',
                //         border: InputBorder.none,
                //       ),
                //     ),
                //   ),
                // ),

                // Container(
                //   margin: const EdgeInsets.only(
                //     bottom: 20,
                //     right: 20,
                //   ),
                //   child: ElevatedButton(
                //     onPressed: () {
                //       _addToDoItem(_todoController.text);
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.blue, // Background color
                //       foregroundColor: Colors.white,
                //     ),
                //     child: const Text(
                //       '+',
                //       style: TextStyle(
                //         fontSize: 20,
                //       ),
                //     ),
                //   ),
                // ),

                Container(
                  // margin: const EdgeInsets.only(bottom: 20, right: 20),
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddTodoPage()),
                      ).then((value) {
                          print(value); // This will print the whole map

                          if (value != null && value is Map) {

                            _addToDoItem(value['todoText'], value['todoNote']);
                          }
                        });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      '+',
                      style: TextStyle(fontSize: 20),
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
    setState(() {
      todoList.removeWhere((item) => item.id == id);
    });
  }

  void _searchTodo(String enterKeyword) {
    List<ToDo> results = [];
    if (enterKeyword.isEmpty) {
      results = todoList;
    } else {
      results = todoList
          .where((item) =>
              item.todoText!.toLowerCase().contains(enterKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundTodo = results;
    });
  }

  void _updateTodoItem(String updatedText,String updateNote,DateTime? updateDate,TimeOfDay? updateTime,String id) {
    setState(() {
      final index = todoList.indexWhere((item) => item.id == id);
      if (index != -1) {
        todoList[index].todoText = updatedText;
        todoList[index].todoNote = updateNote; 
        todoList[index].date = updateDate; // Update date if needed
        todoList[index].time = updateTime; // Update time if needed
      }
    });
  }

  void _addToDoItem(String todo,String todoNote) {
    if (todo.isNotEmpty) {
      setState(() {
        todoList.add(ToDo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          todoText: todo,
          todoNote: todoNote, // You can add a note here if needed
          date: DateTime.now(), // Add current date
          time: TimeOfDay.now(), // Add current time
        ));
        _todoController.clear();
      });
      _todoController.clear();
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
