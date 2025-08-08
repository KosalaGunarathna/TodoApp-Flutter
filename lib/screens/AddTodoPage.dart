import 'package:flutter/material.dart';

class AddTodoPage extends StatefulWidget {
  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: Text('Add New Todo')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [ 

            //text field for todo item
            TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2), // active color
          ),
              labelText: 'Enter New todo Item',
            ),
      
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),

           
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  Navigator.pop(context, _controller.text); // return value
                }
              },
              child: Text('Add Todo'),
            ),
          ],
        ),
      ),
    );
  }
}
