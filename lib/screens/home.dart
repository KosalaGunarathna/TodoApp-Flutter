import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todoapp/color_theam/color.dart';
import 'package:todoapp/screens/AddTodoPage.dart';
import 'package:todoapp/service/service.dart';
import '../widgets/todo_item.dart';
import '../model/todo.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Box<ToDo> todoBox;
  late TodoService todoService;
  List<ToDo> _foundTodo = [];

  @override
  void initState() {
    super.initState();
    todoBox = Hive.box<ToDo>('todos');
    todoService = TodoService(todoBox);
    _loadTodos();
  }

  void _loadTodos() {
    setState(() {
      _foundTodo = todoService.getAllTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;
    final horizontalPadding = isTablet ? screenWidth * 0.1 : 15.0;

    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(isTablet),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          // ── List area ────────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(horizontalPadding, 15, horizontalPadding, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBox(),
                  const Padding(
                    padding: EdgeInsets.only(top: 6, bottom: 10),
                    child: Text(
                      'All Todos',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 12),
                      itemCount: _foundTodo.length,
                      itemBuilder: (context, index) {
                        final todo = _foundTodo.reversed.toList()[index];
                        return ToDoItem(
                          todo: todo,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem: _handleDeleteItem,
                          onUpdateItem: _updateTodoItem,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Add New Todo bar ─────────────────────────────────────────────
          Container(
            color: tdBGColor,
            padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Icon badge
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.add_task_rounded, color: Colors.blue, size: 22),
                  ),
                  const SizedBox(width: 14),

                  // Label
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Add New Todo',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Tap to create a new task',
                          style: TextStyle(fontSize: 12, color: Colors.black45),
                        ),
                      ],
                    ),
                  ),

                  // Add button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddTodoPage()),
                      ).then((value) {
                        if (value != null && value is Map) {
                          _addToDoItem(value['todoText'], value['todoNote'], value['date'], value['time']);
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
      todo.save();
    });
  }

  void _handleDeleteItem(String id) {
    todoService.deleteTodo(id);
    _loadTodos();
  }

  void _searchTodo(String keyword) {
    setState(() {
      _foundTodo = todoService.searchTodos(keyword);
    });
  }

  void _updateTodoItem(String updatedText, String updatedNote, DateTime? date, TimeOfDay? time, String id) {
    todoService.updateTodo(id, updatedText, updatedNote, date, time);
    _loadTodos();
  }

  void _addToDoItem(String todoText, String todoNote, DateTime? date, TimeOfDay? time) {
    todoService.addTodo(todoText, todoNote, date, time);
    _loadTodos();
  }

  Widget _buildSearchBox() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: tdBlack),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: _searchTodo,
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

  AppBar _buildAppBar(bool isTablet) {
    return AppBar(
      centerTitle: true,
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.menu, color: tdBlack, size: 30),
          Text(
            'Todo List',
            style: TextStyle(
              color: Colors.black,
              fontSize: isTablet ? 24 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: isTablet ? 36 : 28,
            width: isTablet ? 36 : 28,
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