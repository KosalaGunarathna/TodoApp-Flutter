import 'package:flutter/material.dart';
import 'package:todoapp/color_theam/color.dart';
import '../widgets/todo_item.dart';
import '../model/todo.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final todoList = ToDo.todoList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buidAppBar(),
      body: Stack(
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                children: [
                  searchBox(),
                  Expanded(
                    child: ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: 10,
                            bottom: 20,
                          ),
                          child: const Text(
                            'All ToDos',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        for (ToDo todoo in todoList) 
                        ToDoItem.ToDoItem(todo:todoo,),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            //addd new item

            Align(
              alignment: Alignment.bottomCenter,
              child: Row(children: [
                Expanded(
                  child: Container(
                  margin: const EdgeInsets.only(
                    bottom:20 ,
                    right:20,
                    left: 20 ),
                     padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color:Colors.white,
                      boxShadow: const [BoxShadow(color: Colors.grey,
                      offset: Offset(0.0,0.0),
                      blurRadius: 10.0,
                      spreadRadius: 0.0
                      ),],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const TextField(decoration: InputDecoration(
                      hintText: 'Add a new todo item',
                      border: InputBorder.none,
                     
                    ),
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                  ),
                  child: ElevatedButton(onPressed: (){},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,     // Background color
                    foregroundColor: Colors.white,
                   
                   ),
                   child: Text('+',style: TextStyle(
                    fontSize: 20, 
                   ),),
                   ),
                ),
                
            
                
              ],),
            ),
        ],
      ),
    );
  }

  Widget searchBox() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: tdBlack),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
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
          Container(
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
