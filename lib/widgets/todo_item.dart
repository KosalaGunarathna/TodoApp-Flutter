import 'package:flutter/material.dart';
import 'package:todoapp/color_theam/color.dart';
import 'package:todoapp/model/todo.dart';
import 'package:custom_check_box/custom_check_box.dart';
import 'package:todoapp/screens/UpdateTodoPage.dart';
import 'package:todoapp/screens/home.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final onToDoChanged;
  final onDeleteItem;
  final onUpdateItem;
  

  const ToDoItem(
      {Key? key,
      required this.todo,
      required this.onDeleteItem,
      required this.onToDoChanged,
      required this.onUpdateItem,

      })
      : super(key: key);
      

  @override
  Widget build(BuildContext context) {
    //   return Container(
    //       margin: EdgeInsets.only(bottom: 15),
    //       child: ListTile(
    //           contentPadding: const EdgeInsets.only(
    //             left: 20,
    //           ),
    //           onTap: () {
    //             // print("click on todo items");
    //             onToDoChanged(todo);
    //           },
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(10),
    //           ),
    //           tileColor: Colors.white,

    //           // ✅ Checkbox icon
    //           leading: Icon(
    //             todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
    //             color: Colors.blue,

    //           ),

    //           // ✅ text
    //           title: Text(
    //             todo.todoText!,
    //             style: TextStyle(
    //               fontSize: 16,
    //               color: tdBlack,
    //               decoration: todo.isDone ? TextDecoration.lineThrough : null,
    //             ),
    //           ),

    //           /// ✅ delet button
    //           trailing: IconButton(
    //             icon: const Icon(Icons.delete, color: tdRed),
    //             onPressed: () {
    //               // print('click delet button');
    //               onDeleteItem(todo.id);
    //             },
    //           )));

    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: ListTile(
        contentPadding: const EdgeInsets.only(
          left: 20,
        ),
        onTap: () {
          // print("click on todo items");
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    UpdateTodoPage(currentText: todo.todoText!)),
          ).then((updatedText) {
            if (updatedText != null && updatedText is String) {
              onUpdateItem(updatedText, todo.id);
              print(updatedText);
              print(todo.id);
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
        ),
      ),
    );
  }
}
