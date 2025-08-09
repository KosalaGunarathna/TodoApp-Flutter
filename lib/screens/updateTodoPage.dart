import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';

class UpdateTodoPage extends StatefulWidget {
  final String currentText;
  final String? currentNote;
  final DateTime? currentDate; // Initialize selected date to null
  final TimeOfDay? currentTime;

  const UpdateTodoPage({
    super.key,
    required this.currentText,
    this.currentNote,
    this.currentDate,
    this.currentTime,
  });

  @override
  State<UpdateTodoPage> createState() => _UpdateTodoPageState();
}

class _UpdateTodoPageState extends State<UpdateTodoPage> {
  late TextEditingController _controller;
  late TextEditingController _noteController;
  late DateTime? _date; // Initialize selected date to null
  late TimeOfDay? _time;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentText);
    _noteController = TextEditingController(text: widget.currentNote ?? '');
    _date = widget.currentDate;
    _time = widget.currentTime; // Default to current date
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Todo',
      style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),
      textAlign: TextAlign.center,
      ),),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter New Todo',
                hintStyle: TextStyle(fontWeight: FontWeight.normal),
                border: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),

            SizedBox(height: 20),

            //todo note
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                hintText: 'Add Note',
                hintStyle: TextStyle(fontWeight: FontWeight.normal),
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
              initialValue: _date,
              decoration: const InputDecoration(
                labelText: 'Select Date',
                border: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              mode: DateTimeFieldPickerMode.date, // Only date
              onChanged: (DateTime? value) {
                setState(() {
                  if (value != null) {
                    _date = value != null
                        ? DateTime(value.year, value.month, value.day)
                        : null;
                  } else {
                    _date = null; // Reset date if value is null
                  }
                  print('Selected Date: $_date');
                });
              },
            ),

            const SizedBox(height: 20),

            // Time Picker
            DateTimeFormField(
              initialValue: _time != null
                  ? DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      _time!.hour,
                      _time!.minute,
                    )
                  : null,
              decoration: const InputDecoration(
                labelText: 'Select Time',
                border: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              mode: DateTimeFieldPickerMode.time, // Only time
              onChanged: (DateTime? value) {
                setState(() {
                  if (value != null) {
                    _time = value != null
                        ? TimeOfDay(hour: value.hour, minute: value.minute)
                        : null;
                  } else {
                    _time = null; // Reset time if value is null
                  }
                  print('Selected Time: $_time');
                });
              },
            ),

            SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // background color
                foregroundColor: Colors.white, // text color
              ),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  print("date : $_date");
                  print("Time : $_time");
                  Navigator.pop(context, {
                    'todoText': _controller.text,
                    'todoNote': _noteController.text,
                    'date': _date,
                    'time': _time,
                  }); // return value
                }
              },
              child: const Text('Update Todo'),
            ),
          ],
        ),
      ),
    );
  }
}
