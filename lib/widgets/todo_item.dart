import 'package:flutter/material.dart';
import 'package:todoapp/color_theam/color.dart';
import 'package:todoapp/model/todo.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final onToDoChanged;
  final onDeleteItem;

  const ToDoItem({Key? key, required this.todo,required this.onDeleteItem,required this.onToDoChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 15),
        child: ListTile(
            contentPadding: const EdgeInsets.only(
              left: 20,
            ),
            onTap: () {
              // print("click on todo items");
              onToDoChanged(todo);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            tileColor: Colors.white,

            // ✅ Checkbox icon
            leading: Icon(
              todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
              color: Colors.blue,
            ),

            // ✅ text
            title: Text(
              todo.todoText!,
              style: TextStyle(
                fontSize: 16,
                color: tdBlack,
                decoration: todo.isDone ? TextDecoration.lineThrough : null,
              ),
            ),

            /// ✅ delet button
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: tdRed),
              onPressed: () {
                // print('click delet button');
                onDeleteItem(todo.id);
              },
            )));
  }
}
