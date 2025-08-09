import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';

class UpdateTodoPage extends StatefulWidget {
  final String currentText;
  final String? currentNote;

  UpdateTodoPage({
    Key? key,
    required this.currentText,
    required this.currentNote,
  }) : super(key: key);

  @override
  State<UpdateTodoPage> createState() => _UpdateTodoPageState();
}

class _UpdateTodoPageState extends State<UpdateTodoPage> {
  late TextEditingController _controller;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentText);
    _noteController = TextEditingController(text: widget.currentNote ?? '');
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

            //todo note
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                hintText: 'Add note',
                border: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              keyboardType: TextInputType.multiline,
              // maxLines: 2,
            ),

            const SizedBox(height: 20),

            DateTimeFormField(
              decoration: const InputDecoration(
                labelText: 'Select Date',
                border: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              mode: DateTimeFieldPickerMode.date, // Only date
              onChanged: (DateTime? value) {
                print('Selected Date: $value');
              },
            ),

            SizedBox(height: 20),

            // Time Picker
            DateTimeFormField(
              decoration: const InputDecoration(
                labelText: 'Select Time',
                border: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              mode: DateTimeFieldPickerMode.time, // Only time
              onChanged: (DateTime? value) {
                print('Selected Time: $value');
              },
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // background color
                foregroundColor: Colors.white, // text color
              ),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  Navigator.pop(context, {
                    'todoText' : _controller.text,
                    'todoNote': _noteController.text,
                    }); // return value
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
