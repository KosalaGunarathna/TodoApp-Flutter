import 'package:go_router/go_router.dart';
import 'package:todoapp/model/todo.dart';
import 'package:todoapp/screens/AddTodoPage.dart';
import 'package:todoapp/screens/home.dart';
import 'package:todoapp/screens/updateTodoPage.dart';

class AppRoutes {
  static final GoRouter routes = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Home(),
      ),
      GoRoute(
        path: '/add',
        builder: (context, state) => const AddTodoPage(),
      ),
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
    ],
  );
}
