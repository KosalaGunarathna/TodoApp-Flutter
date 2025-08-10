import 'package:flutter/material.dart';
import 'package:todoapp/color_theam/color.dart';
import 'package:todoapp/model/todo.dart';
import 'package:custom_check_box/custom_check_box.dart';
import 'package:todoapp/screens/UpdateTodoPage.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final onToDoChanged;
  final onDeleteItem;
  final onUpdateItem;

  const ToDoItem({
    super.key,
    required this.todo,
    required this.onDeleteItem,
    required this.onToDoChanged,
    required this.onUpdateItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        contentPadding: const EdgeInsets.only(
          left: 5,
        ),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateTodoPage(
                currentText: todo.todoText!,
                currentNote: todo.todoNote,
                currentDate: todo.date,
                currentTime: todo.time,
              ),
            ),
          ).then((updatedText) {
            if (updatedText['todoText'] != null && updatedText is Map) {
              onUpdateItem(
                updatedText['todoText'],
                updatedText['todoNote'],
                updatedText['date'],
                updatedText['time'],
                todo.id,
              );
            }
          });
        },

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        tileColor: Colors.white,

        // ✅ Checkbox icon
        leading: CustomCheckBox(
          value: todo.isDone,
          checkedFillColor: Colors.blue,
          checkBoxSize: 15,
          borderRadius: 3,
          onChanged: (val) {
            onToDoChanged(todo);
            
          },
        ),

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todo.todoText!,
              style: TextStyle(
                fontSize: 16,
                color: tdBlack,
                decoration: todo.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
            const SizedBox(height: 5),

            // Text(
            todo.todoNote == null || todo.todoNote!.isEmpty
                ? const SizedBox.shrink()
                : Text(
                    todo.todoNote!,
                    style: TextStyle(
                      fontSize: 12,
                      color: tdGrey,
                      decoration: todo.isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
          ],
        ),

        // ✅ time

        subtitle: Align(
          alignment: Alignment.centerRight,
          child: Column(
            children: [
              todo.time == null
                  ? const SizedBox.shrink() // hides the widget, takes no space
                  : Text(
                      todo.time!.format(context),
                      style: TextStyle(
                        fontSize: 10, color: tdGrey,
                        decoration: todo.isDone ? TextDecoration.lineThrough : null,
                        ),

                    ),

              const SizedBox(height: 2),

              // ✅ date
              todo.date == null
                  ? const SizedBox.shrink()
                  : Text(
                      '${todo.date!.year}-${todo.date!.month.toString().padLeft(2, '0')}-${todo.date!.day.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 10, color: tdGrey,
                        decoration: todo.isDone ? TextDecoration.lineThrough : null,
                        ),
                    )
            ],
          ),
        ),

        // ✅ delet button
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: tdRed),
          onPressed: () {
            showDialog(context: context,
             builder: (context) {
              return AlertDialog(
                title: const Text('Delete Todo'),
                content: const Text('Are you sure you want to delete this todo?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      onDeleteItem(todo.id);
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Delete',style: TextStyle(color: tdRed)),
                  ),
                ],
              );
             });

            // print('click delet button');
            // onDeleteItem(todo.id);
          },
        ),
      ),
    );
  }
}
