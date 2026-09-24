import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/timezone.dart' as tz;

import '../models/todo.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  // Initialize notifications.
  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await plugin.initialize(settings: settings);
  }

  static Future<void> requestPermission() async {
    await plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  // Read the reminder delay.
  static int _getReminderMinutes() {
    try {
      final box = Hive.box('settings');
      return box.get('reminderMinutes', defaultValue: 60) as int;
    } catch (e) {
      return 60;
    }
  }

  // Read a boolean setting.
  static bool _getBool(String key, bool defaultValue) {
    try {
      final box = Hive.box('settings');
      return box.get(key, defaultValue: defaultValue) as bool;
    } catch (e) {
      return defaultValue;
    }
  }

  // Schedule a todo reminder.
  static Future<void> scheduleTodo(ToDo todo) async {
    if (todo.date == null || todo.time == null) return;

    // Read user settings.
    final bool notificationsEnabled = _getBool('notificationsEnabled', true);
    final bool soundEnabled = _getBool('soundEnabled', true);
    final bool vibrationEnabled = _getBool('vibrationEnabled', true);

    // Stop when notifications are disabled.
    if (!notificationsEnabled) return;

    final taskDateTime = DateTime(
      todo.date!.year,
      todo.date!.month,
      todo.date!.day,
      todo.time!.hour,
      todo.time!.minute,
    );

    final reminderMinutes = _getReminderMinutes();
    final reminderTime = taskDateTime.subtract(
      Duration(minutes: reminderMinutes),
    );

    // Skip past reminders.
    if (reminderTime.isBefore(DateTime.now())) {
      debugPrint('Skipping notification: reminder time is in the past.');
      return;
    }

    await plugin.zonedSchedule(
      id: todo.id.hashCode,
      title: todo.todoText ?? 'Todo Reminder',
      body: _buildBody(reminderMinutes),
      scheduledDate: tz.TZDateTime.from(reminderTime, tz.local),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'todo_channel',
          'Todo Notifications',
          channelDescription: 'Todo reminder notification',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/launcher_icon',
          playSound: soundEnabled, // sound on/off
          enableVibration: vibrationEnabled, // vibration on/off
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  // Reschedule all reminders.
  static Future<void> rescheduleAll(List<ToDo> todos) async {
    await plugin.cancelAll();
    for (final todo in todos) {
      await scheduleTodo(todo);
    }
  }

  // Cancel one reminder.
  static Future<void> cancelNotification(String todoId) async {
    await plugin.cancel(id: todoId.hashCode);
  }

  // Build reminder text.
  static String _buildBody(int minutes) {
    if (minutes < 60) return 'Due in $minutes minutes!';
    if (minutes == 60) return 'Due in 1 hour!';
    if (minutes < 1440) {
      final h = minutes ~/ 60;
      final m = minutes % 60;
      if (m == 0) return 'Due in $h hours!';
      return 'Due in ${h}h ${m}m!';
    }
    final days = minutes ~/ 1440;
    return 'Due in $days day${days > 1 ? 's' : ''}!';
  }
}
