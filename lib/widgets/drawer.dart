import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/color_theam/color.dart';


class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  bool _darkMode = false;
  late Box _settingsBox;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      if (!Hive.isBoxOpen('settings')) {
        _settingsBox = await Hive.openBox('settings');
      } else {
        _settingsBox = Hive.box('settings');
      }
      setState(() {
        _darkMode = _settingsBox.get('darkMode', defaultValue: false);
      });
    } catch (e) {
      print('Error loading settings: $e');
    }
  }

  void _go(BuildContext context, String route) {
    Navigator.pop(context); // Close drawer
    Future.delayed(const Duration(milliseconds: 200), () {
      context.go(route); // Navigate after drawer closes
    });
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = getBGColor(_darkMode);
    final textColor = getTextColor(_darkMode);

    return Drawer(
      backgroundColor: bgColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 70,
            color: tdIconNotifications,
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: textColor),
            title: Text('Home', style: TextStyle(color: textColor)),
            onTap: () => _go(context, '/'),
          ),
          ListTile(
            leading: Icon(Icons.notifications, color: textColor),
            title: Text('Notifications', style: TextStyle(color: textColor)),
            onTap: () => _go(context, '/notifications'),
          ),
          ListTile(
            leading: Icon(Icons.settings, color: textColor),
            title: Text('Settings', style: TextStyle(color: textColor)),
            onTap: () => _go(context, '/settings'),
          ),
          ListTile(
            leading: Icon(Icons.info, color: textColor),
            title: Text('About', style: TextStyle(color: textColor)),
            onTap: () => _go(context, '/about'),
          ),
        ],
      ),
    );
  }
}
