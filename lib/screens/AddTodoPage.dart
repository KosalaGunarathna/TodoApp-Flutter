import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:todoapp/screens/home.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _notecontroller = TextEditingController();
  DateTime? _date; // Initialize selected date to null
  TimeOfDay? _time;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(title: const Text('Add New Todo', 
      style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),
      textAlign: TextAlign.center,
      )),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter New Todo Item',
                hintStyle: TextStyle(fontWeight: FontWeight.normal),
                border: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              keyboardType: TextInputType.multiline,
            ),

            const SizedBox(height: 20),

            //todo note
            TextFormField(
              controller: _notecontroller,
              decoration: const InputDecoration(
                hintText: 'Add Note',
                hintStyle: TextStyle(fontWeight: FontWeight.normal),
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
                setState(() {
                  if (value != null) {
                    _date = value != null
                        ? DateTime(value.year, value.month, value.day)
                        : null;
                  }
                  print('Selected Date: $_date');
                });
              },
            ),

            const SizedBox(height: 20),

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
                
                setState(() {
                  if (value != null) {
                    _time = value != null
                    ? TimeOfDay(hour: value.hour, minute: value.minute)
                    : null;
                  }
                  print('Selected Time: $_time');
                });
              },
            ),

            const SizedBox(height: 20),

          
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // background color
                    foregroundColor: Colors.white, // text color
                    // padding: const EdgeInsets.symmetric(horizontal: 12, vertical:-5 ),
                    fixedSize: Size(100, 5),
                    textStyle: const TextStyle(fontSize: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(),
                        ));
                  },
                  child: Text('Cancel'),
                ),

                ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // background color
                foregroundColor: Colors.white, // text color
                fixedSize: Size(125, 5),
                    textStyle: const TextStyle(fontSize: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
              ),
              onPressed: () {
                // print("time: $_time");
                // print("date :$_date");

                if (_controller.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Required",style: TextStyle(fontSize: 20)  ),
                        content: const Text("Please enter a Todo Item."),
                        actions: [
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
                
                if (_controller.text.isNotEmpty) {
                  Navigator.pop(context, {
                    'todoText': _controller.text,
                    'todoNote': _notecontroller.text,
                    'date': _date, // Add date if needed
                    'time': _time, // Add time if needed
                  }); // return value
                }
              },
              child: const Text('Add Todo'),
              ),
                
              ],
            )),

              

          ],
        ),
      ),
    );
  }
}
