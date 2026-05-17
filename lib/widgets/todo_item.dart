import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todoapp/color_theam/color.dart';
import 'package:todoapp/model/todo.dart';
import 'package:custom_check_box/custom_check_box.dart';

import 'package:hive_flutter/hive_flutter.dart';

class ToDoItem extends StatefulWidget {
  final ToDo todo;
  // ignore: prefer_typing_uninitialized_variables
  final onDeleteItem;
  final void Function(ToDo todo) onToDoChanged;
  final void Function(String updatedText, String updateNote,
      DateTime? updateDate, TimeOfDay? updateTime, String id) onUpdateItem;

  const ToDoItem({
    super.key,
    required this.todo,
    required this.onDeleteItem,
    required this.onToDoChanged,
    required this.onUpdateItem,
  });

  @override
  State<ToDoItem> createState() => _ToDoItemState();
}

class _ToDoItemState extends State<ToDoItem> {
  bool _darkMode = false;
  late Box _settingsBox;

  @override
  void initState() {
    super.initState();
    _loadSettings();
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

  @override
  Widget build(BuildContext context) {
    final cardColor = getCardColor(_darkMode);
    final textColor = getTextColor(_darkMode);
    final subtitleColor = getSubtitleColor(_darkMode);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        contentPadding: const EdgeInsets.only(
          left: 5,
        ),

        onTap: () async {
        final result = await context.push('/update', extra: widget.todo);
        
        if (result is Map) {
          widget.onUpdateItem(
            result['todoText'],
            result['todoNote'],
            result['date'],
            result['time'],
            widget.todo.id!,
          );
        }
      },

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        tileColor: cardColor,

        // ✅ Checkbox icon
        leading: CustomCheckBox(
          value: widget.todo.isDone,
          checkedFillColor: Colors.blue,
          checkBoxSize: 15,
          borderRadius: 3,
          onChanged: (val) {
            widget.onToDoChanged(widget.todo);
          },
        ),

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.todo.todoText!,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
                decoration: widget.todo.isDone ? TextDecoration.lineThrough : null,
                decorationColor: textColor,
              ),
            ),
            const SizedBox(height: 5),

            // Text for todo note
            widget.todo.todoNote == null || widget.todo.todoNote!.isEmpty
                ? const SizedBox.shrink()
                : Text(
                    widget.todo.todoNote!,
                    style: TextStyle(
                      fontSize: 14,
                      color: subtitleColor,
                      decoration: widget.todo.isDone ? TextDecoration.lineThrough : null,
                      decorationColor: textColor,
                    ),
                  ),
          ],
        ),

        // ✅ time

        subtitle: Align(
          alignment: Alignment.centerRight,
          child: Column(
            children: [
              widget.todo.time == null
                  ? const SizedBox.shrink() // hides the widget, takes no space
                  : Text(
                      widget.todo.time.toString().substring(10, 15),
                      style: TextStyle(
                        fontSize: 12,
                        color: tdGrey,
                        decoration:
                            widget.todo.isDone ? TextDecoration.lineThrough : null,
                        decorationColor: textColor,
                      ),
                    ),

              const SizedBox(height: 2),

              // ✅ date
              widget.todo.date == null
                  ? const SizedBox.shrink()
                  : Text(
                      '${widget.todo.date!.year}-${widget.todo.date!.month.toString().padLeft(2, '0')}-${widget.todo.date!.day.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 12,
                        color: tdGrey,
                        decoration:
                            widget.todo.isDone ? TextDecoration.lineThrough : null,
                            decorationColor: textColor,
                      ),
                    )
            ],
          ),
        ),

        // ✅ delete button
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: tdRed),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete Todo'),
                    content: const Text(
                        'Are you sure you want to delete this todo?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          widget.onDeleteItem(widget.todo.id);
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text('Delete',
                            style: TextStyle(color: tdRed)),
                      ),
                    ],
                  );
                });
          },
        ),
      ),
    );
  }
}
