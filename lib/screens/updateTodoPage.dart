import 'package:flutter/material.dart';

class UpdateTodoPage extends StatefulWidget {
  final String currentText;

  const UpdateTodoPage({Key? key, required this.currentText}) : super(key: key);

  @override
  State<UpdateTodoPage> createState() => _UpdateTodoPageState();
}

class _UpdateTodoPageState extends State<UpdateTodoPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentText);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Todo')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: ' new todo',
                border: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
               style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // background color
                foregroundColor: Colors.white, // text color
              ),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  Navigator.pop(context, _controller.text); // return value
                }
              },
              child: Text('Update Todo'),
            ),
          ],
        ),
      ),
    );
  }
}
