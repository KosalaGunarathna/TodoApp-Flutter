import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timezone/data/latest.dart' as tzdata;  // ← change tz to tzdata
import 'package:timezone/timezone.dart' as tz;          // ← keep as tz
import 'package:todoapp/model/time_of_day_adapter.dart';
import 'package:todoapp/model/todo.dart';
import 'package:todoapp/screens/home.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/service/notification_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  tzdata.initializeTimeZones();                              // ← tzdata

  Hive.registerAdapter(ToDoAdapter());
  Hive.registerAdapter(TimeOfDayAdapter());

  await Hive.openBox<ToDo>('todos');

  await NotificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Make status bar transparent
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      home: Home(),
    );
  }
}
