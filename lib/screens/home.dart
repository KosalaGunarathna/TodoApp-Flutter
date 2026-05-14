import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todoapp/color_theam/color.dart';
import 'package:todoapp/service/service.dart';
import 'package:todoapp/widgets/drawer.dart';
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
  late Box _settingsBox;
  List<ToDo> _foundTodo = [];
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    todoBox = Hive.box<ToDo>('todos');
    todoService = TodoService(todoBox);
    _loadSettings();
    _loadTodos();
  }

  Future<void> _loadSettings() async {
    try {
      if (!Hive.isBoxOpen('settings')) {
        _settingsBox = await Hive.openBox('settings');
      } else {
        _settingsBox = Hive.box('settings');
      }
      setState(() {
        _darkMode = _settingsBox.get('darkMode', defaultValue: false);
      });
    } catch (e) {
      print('Error loading settings: $e');
    }
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
    final bgColor = getBGColor(_darkMode);
    final cardColor = getCardColor(_darkMode);
    final textColor = getTextColor(_darkMode);
    final subtitleColor = getSubtitleColor(_darkMode);

    return Scaffold(
      backgroundColor: bgColor,
      drawer: const DrawerWidget(),
      appBar: _buildAppBar(isTablet, bgColor, textColor),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── List area ────────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  horizontalPadding, 15, horizontalPadding, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBox(textColor),
                  Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 10),
                    child: Text(
                      'All Todos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
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
            color: bgColor,
            padding: EdgeInsets.fromLTRB(
                horizontalPadding, 8, horizontalPadding, 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(_darkMode ? 0.3 : 0.10),
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
                    child: const Icon(Icons.add_task_rounded,
                        color: Colors.blue, size: 22),
                  ),
                  const SizedBox(width: 14),

                  // Label
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Add New Todo',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: textColor),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Tap to create a new task',
                          style: TextStyle(fontSize: 12, color: subtitleColor),
                        ),
                      ],
                    ),
                  ),

                  // Add button
                  ElevatedButton(
                    onPressed: () {
                      context.push('/add');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                      textStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    child: const Text('Add'),
                  )
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

  void _updateTodoItem(String updatedText, String updatedNote, DateTime? date,
      TimeOfDay? time, String id) {
    todoService.updateTodo(id, updatedText, updatedNote, date, time);
    _loadTodos();
  }

  Widget _buildSearchBox(Color textColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
      decoration: BoxDecoration(
        color: getCardColor(_darkMode),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(_darkMode ? 0.3 : 0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: textColor),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: _searchTodo,
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
              ),
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(bool isTablet, Color bgColor, Color textColor) {
    return AppBar(
      centerTitle: true,
      backgroundColor: bgColor,
      elevation: 0,

      // LEFT ICON
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(
            Icons.menu,
            color: textColor,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),

      // CENTER TITLE
      title: Text(
        'Todo List',
        style: TextStyle(
          color: textColor,
          fontSize: isTablet ? 24 : 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // RIGHT SIDE
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: SizedBox(
            height: isTablet ? 36 : 28,
            width: isTablet ? 36 : 28,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/profile.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
