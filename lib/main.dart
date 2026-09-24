import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todoapp/routes/app_router.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:todoapp/models/time_of_day_adapter.dart';
import 'package:todoapp/models/todo.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/services/notification_service.dart';
import 'package:todoapp/config/admob_config.dart';

String globalDeviceID = '';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AdmobConfig.load();
  await MobileAds.instance.initialize();
  await Hive.initFlutter();
  tzdata.initializeTimeZones(); // Initialize time zones.
  Hive.registerAdapter(ToDoAdapter());
  Hive.registerAdapter(TimeOfDayAdapter());
  final todoBox = await Hive.openBox<ToDo>('todos');
  try {
    final settingsBox = await Hive.openBox('settings');
    if (settingsBox.get('exampleTodosAdded', defaultValue: false) != true) {
      if (todoBox.isEmpty) {
        await todoBox.putAll({
          'example-1': ToDo(
            id: 'example-1',
            todoText: 'Plan the day',
            todoNote: 'Review priorities and set three goals.',
          ),
          'example-2': ToDo(
            id: 'example-2',
            todoText: 'Drink enough water',
            todoNote: 'Keep a water bottle nearby today.',
          ),
          'example-3': ToDo(
            id: 'example-3',
            todoText: 'Take a short break',
            todoNote: 'Step away from the screen for a few minutes.',
          ),
        });
      }
      await settingsBox.put('exampleTodosAdded', true);
    }
  } catch (error) {
    debugPrint('Could not add example todos: $error');
  }
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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      routerConfig: AppRoutes.routes,
    );
  }
}
