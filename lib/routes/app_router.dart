import 'package:go_router/go_router.dart';
import 'package:todoapp/models/todo.dart';
import 'package:todoapp/screens/about_screen.dart';
import 'package:todoapp/screens/add_todo_page.dart';
import 'package:todoapp/screens/home_screen.dart';
import 'package:todoapp/screens/notification_screen.dart';
import 'package:todoapp/screens/privacy_policy_screen.dart';
import 'package:todoapp/screens/settings_screen.dart';
import 'package:todoapp/screens/terms_and_conditions_screen.dart';
import 'package:todoapp/screens/update_todo_page.dart';

class AppRoutes {
  static final GoRouter routes = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const Home()),
      GoRoute(path: '/add', builder: (context, state) => const AddTodoPage()),
      GoRoute(
        path: '/update',
        builder: (context, state) {
          final todo = state.extra as ToDo?;

          return UpdateTodoPage(
            currentText: todo?.todoText ?? '',
            currentNote: todo?.todoNote,
            currentDate: todo?.date,
            currentTime: todo?.time,
          );
        },
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationPage(),
      ),
      GoRoute(path: '/settings', builder: (context, state) => const Setting()),
      GoRoute(
        path: '/terms',
        builder: (context, state) => const TermsAndConditions(),
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(path: '/about', builder: (context, state) => const About()),
    ],
  );
}
