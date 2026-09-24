import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todoapp/models/todo.dart';
import 'package:todoapp/services/todo_service.dart';
import 'package:todoapp/theme/app_colors.dart';
import 'package:todoapp/widgets/admob_banner_widget.dart';
import 'package:todoapp/widgets/app_drawer.dart';
import 'package:todoapp/widgets/todo_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Box<ToDo> todoBox;
  late TodoService todoService;
  late Box _settingsBox;
  List<ToDo> _foundTodo = [];
  bool _darkMode = false;
  bool notificationsEnabled = true;

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
        notificationsEnabled = _settingsBox.get(
          'notificationsEnabled',
          defaultValue: true,
        );
      });
    } catch (e) {
      debugPrint('Error loading settings: $e');
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
        children: [
          // Todo list.
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    15,
                    horizontalPadding,
                    0,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Search field.
                      _buildSearchBox(textColor),

                      // Section label.
                      Padding(
                        padding: const EdgeInsets.only(top: 6, bottom: 10),
                        child: Text(
                          'All Tasks',
                          style: TextStyle(
                            fontSize: isTablet ? 22 : 18,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),

                // Todo items
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    0,
                    horizontalPadding,
                    12,
                  ),
                  sliver: SliverList.builder(
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

          // Add todo bar.
          Container(
            color: bgColor,
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              8,
              horizontalPadding,
              16,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: _darkMode ? 0.3 : 0.10,
                    ),
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
                      color: Colors.blue.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.add_task_rounded,
                      color: Colors.blue,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Label
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Add New Task',
                          style: TextStyle(
                            fontSize: isTablet ? 16 : 15,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Tap to create a new task',
                          style: TextStyle(
                            fontSize: isTablet ? 13 : 12,
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Add button
                  ElevatedButton(
                    onPressed: () async {
                      final result = await context.push('/add');
                      if (result != null && result is Map) {
                        debugPrint('Add page returned: $result');
                        final todoText = result['todoText'] as String? ?? '';
                        final todoNote = result['todoNote'] as String? ?? '';
                        final date = result['date'] as DateTime?;
                        final time = result['time'] as TimeOfDay?;
                        if (todoText.isNotEmpty) {
                          await todoService.addTodo(
                            todoText,
                            todoNote,
                            date,
                            time,
                          );
                          try {
                            debugPrint(
                              'After add, box length: ${todoBox.length}',
                            );
                          } catch (_) {}
                          _loadTodos();
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      textStyle: TextStyle(
                        fontSize: isTablet ? 15 : 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: screenWidth, child: const AdmobBannerWidget()),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
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

  void _updateTodoItem(
    String updatedText,
    String updatedNote,
    DateTime? date,
    TimeOfDay? time,
    String id,
  ) async {
    await todoService.updateTodo(id, updatedText, updatedNote, date, time);
    if (mounted) {
      setState(() {
        _foundTodo = todoService.getAllTodos();
      });
    }
  }

  Widget _buildSearchBox(Color textColor) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
      decoration: BoxDecoration(
        color: getCardColor(_darkMode),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: _darkMode ? 0.3 : 0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: textColor, size: isTablet ? 24 : 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: _searchTodo,
              style: TextStyle(color: textColor, fontSize: isTablet ? 16 : 14),
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: textColor.withValues(alpha: 0.5),
                  fontSize: isTablet ? 16 : 14,
                ),
              ),
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
          icon: const Icon(Icons.menu_rounded, size: 26),
          color: textColor,
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),

      // CENTER TITLE
      title: Text(
        'Task List',
        style: TextStyle(
          color: textColor,
          fontSize: isTablet ? 24 : 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // RIGHT SIDE
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            icon: Icon(
              notificationsEnabled
                  ? Icons.notifications_rounded
                  : Icons.notifications_off_rounded,
              size: 26,
            ),
            color: notificationsEnabled ? textColor : Colors.grey,
            onPressed: () => context.go('/notifications'),
          ),
        ),
      ],
    );
  }
}
