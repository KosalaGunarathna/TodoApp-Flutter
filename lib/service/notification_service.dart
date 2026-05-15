import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

    // Ask notification permission (Android 13+)
    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // Ask exact alarm permission
    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
  }

  // ── Read reminderMinutes saved by NotificationPage ────────────────────────
  static int _getReminderMinutes() {
    try {
      final box = Hive.box('settings');
      return box.get('reminderMinutes', defaultValue: 60) as int;
    } catch (e) {
      return 60; // fallback: 1 hour
    }
  }

  // ── Schedule a notification for a todo ───────────────────────────────────
  static Future<void> scheduleTodo(ToDo todo) async {
    if (todo.date == null || todo.time == null) return;

    final taskDateTime = DateTime(
      todo.date!.year,
      todo.date!.month,
      todo.date!.day,
      todo.time!.hour,
      todo.time!.minute,
    );

    // Read the user's chosen reminder time from settings
    final reminderMinutes = _getReminderMinutes();
    final reminderTime = taskDateTime.subtract(
      Duration(minutes: reminderMinutes),
    );

    // Don't schedule if reminder time is already in the past
    if (reminderTime.isBefore(DateTime.now())) {
      print('Skipping notification — reminder time is in the past');
      return;
    }

    await plugin.zonedSchedule(
      todo.id.hashCode,
      todo.todoText ?? 'Todo Reminder',
      _buildBody(reminderMinutes),
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

  // ── Reschedule all todos after user changes reminder time ─────────────────
  static Future<void> rescheduleAll(List<ToDo> todos) async {
    // Cancel all existing notifications first
    await plugin.cancelAll();

    // Re-schedule each todo with the new reminder time
    for (final todo in todos) {
      await scheduleTodo(todo);
    }
  }

  // ── Cancel a single notification ──────────────────────────────────────────
  static Future<void> cancelNotification(String todoId) async {
    await plugin.cancel(todoId.hashCode);
  }

  // ── Helper: build notification body text ─────────────────────────────────
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