import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/timezone.dart' as tz;
import '../model/todo.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  // ── Init ──────────────────────────────────────────────────────────────────
  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await plugin.initialize(settings);

    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
  }

  // ── Read reminderMinutes from Hive ────────────────────────────────────────
  static int _getReminderMinutes() {
    try {
      final box = Hive.box('settings');
      return box.get('reminderMinutes', defaultValue: 60) as int;
    } catch (e) {
      return 60;
    }
  }

  // ── Read any bool setting from Hive ───────────────────────────────────────
  static bool _getBool(String key, bool defaultValue) {
    try {
      final box = Hive.box('settings');
      return box.get(key, defaultValue: defaultValue) as bool;
    } catch (e) {
      return defaultValue;
    }
  }

  // ── Schedule a notification for a todo ───────────────────────────────────
  static Future<void> scheduleTodo(ToDo todo) async {
    if (todo.date == null || todo.time == null) return;

    // Read all user settings
    final bool notificationsEnabled = _getBool('notificationsEnabled', true);
    final bool soundEnabled = _getBool('soundEnabled', true);
    final bool vibrationEnabled = _getBool('vibrationEnabled', true);

    
    // Stop if notifications turned off
    if (!notificationsEnabled) return;

    final taskDateTime = DateTime(
      todo.date!.year,
      todo.date!.month,
      todo.date!.day,
      todo.time!.hour,
      todo.time!.minute,
    );

    final reminderMinutes = _getReminderMinutes();
    final reminderTime =
        taskDateTime.subtract(Duration(minutes: reminderMinutes));

    // Skip if reminder time already passed
    if (reminderTime.isBefore(DateTime.now())) {
      print('Skipping notification — reminder time is in the past');
      return;
    } 

    await plugin.zonedSchedule(
      todo.id.hashCode,
      todo.todoText ?? 'Todo Reminder',
      _buildBody(reminderMinutes),
      tz.TZDateTime.from(reminderTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'todo_channel',
          'Todo Notifications',
          channelDescription: 'Todo reminder notification',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/launcher_icon',
          playSound: soundEnabled,           // sound on/off
          enableVibration: vibrationEnabled, // vibration on/off

        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // ── Reschedule all todos (called when settings change) ────────────────────
  static Future<void> rescheduleAll(List<ToDo> todos) async {
    await plugin.cancelAll();
    for (final todo in todos) {
      await scheduleTodo(todo);
    }
  }

  // ── Cancel a single notification ──────────────────────────────────────────
  static Future<void> cancelNotification(String todoId) async {
    await plugin.cancel(todoId.hashCode);
  }

  // ── Build notification body text ──────────────────────────────────────────
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