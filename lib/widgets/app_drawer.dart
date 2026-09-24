// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/theme/app_colors.dart';

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
      debugPrint('Error loading settings: $e');
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
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          const SizedBox(height: 8),
          _drawerItem(
            icon: Icons.home_rounded,
            iconColor: tdIconNotifications,
            title: 'Home',
            textColor: textColor,
            onTap: () => _go(context, '/'),
          ),
          _drawerItem(
            icon: Icons.notifications_rounded,
            iconColor: tdIconNotifications,
            title: 'Notifications',
            textColor: textColor,
            onTap: () => _go(context, '/notifications'),
          ),
          _drawerItem(
            icon: Icons.settings_rounded,
            iconColor: tdIconInfo,
            title: 'Settings',
            textColor: textColor,
            onTap: () => _go(context, '/settings'),
          ),
          _drawerItem(
            icon: Icons.policy_rounded,
            iconColor: tdIconInfo,
            title: 'Terms & Conditions',
            textColor: textColor,
            onTap: () => _go(context, '/terms'),
          ),
          _drawerItem(
            icon: Icons.privacy_tip_rounded,
            iconColor: tdIconInfo,
            title: 'Privacy Policy',
            textColor: textColor,
            onTap: () => _go(context, '/privacy'),
          ),
          _drawerItem(
            icon: Icons.info_outline_rounded,
            iconColor: tdIconInfo,
            title: 'About',
            textColor: textColor,
            onTap: () => _go(context, '/about'),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
