import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../model/todo.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings settings =
      InitializationSettings(android: androidSettings);

  await plugin.initialize(settings);

  // 🔥 Ask notification permission (Android 13+)
  await plugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  // 🔥 Ask exact alarm permission
  await plugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestExactAlarmsPermission();
}

  static Future<void> scheduleTodo(ToDo todo) async {

    if (todo.date == null || todo.time == null) return;

    final taskDateTime = DateTime(
      todo.date!.year,
      todo.date!.month,
      todo.date!.day,
      todo.time!.hour,
      todo.time!.minute,
    );

    // 🔥 Reminder 1 hour before
    final reminderTime = taskDateTime.subtract(
      const Duration(hours: 1),
    );

    await plugin.zonedSchedule(
      todo.id.hashCode,
      '${todo.todoText}',
      'Todo Reminder',
      
      tz.TZDateTime.from(reminderTime, tz.local),

      const NotificationDetails(
        android: AndroidNotificationDetails(
          'todo_channel',
          'Todo Notifications',
          channelDescription: 'Todo reminder notification',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/launcher_icon',
        ),
      ),

      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelNotification(int id) async {
  await plugin.cancel(id);
}
}