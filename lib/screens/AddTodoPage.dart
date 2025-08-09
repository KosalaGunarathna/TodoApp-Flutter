import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';

class AddTodoPage extends StatefulWidget {
  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _notecontroller = TextEditingController();

  // TimeOfDay _selectedTime = TimeOfDay.now();
  // Future<void> _selectTime(BuildContext context) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: _selectedTime,
  //   );
  //   if (picked != null && picked != _selectedTime)
  //     setState(() {
  //       _selectedTime = picked;
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Todo')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter new todo',
                border: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 20),

            //todo note
            TextFormField(
              controller: _notecontroller,
              decoration: const InputDecoration(
                hintText: 'Add note',
                border: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 20),

            //Date
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

            SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () => _selectTime(context),
            //   child: Text('Pick Time'),
            // ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // background color
                foregroundColor: Colors.white, // text color
              ),
              onPressed: () {
                // print(_selectedTime);
                if (_controller.text.isNotEmpty) {
                  Navigator.pop(context, {
                    'todoText': _controller.text,
                    'todoNote': _notecontroller.text,
                  }); // return value
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
