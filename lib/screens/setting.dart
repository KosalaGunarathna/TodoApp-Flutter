import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/color_theam/color.dart';
import 'package:todoapp/model/todo.dart';
import 'package:todoapp/service/notification_service.dart';
import 'package:todoapp/service/service.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  late Box _settingsBox;
  bool _notificationsEnabled = true;
  bool _darkMode = false;
  

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
        _notificationsEnabled =
            _settingsBox.get('notificationsEnabled', defaultValue: true);
        _darkMode = _settingsBox.get('darkMode', defaultValue: false);
      });
    } catch (e) {
      print('Error loading settings: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    try {
      await _settingsBox.put(key, value);
    } catch (e) {
      print('Error saving setting: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = getBGColor(_darkMode);
    final cardColor = getCardColor(_darkMode);
    final textColor = getTextColor(_darkMode);
    final subtitleColor = getSubtitleColor(_darkMode);
    final dividerColor = getDividerColor(_darkMode);
    final sectionLabelColor = getSectionLabelColor(_darkMode);
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () {
            context.go('/');
          },
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),

            // Appearance Section
            _sectionTitle('Appearance', sectionLabelColor),
            const SizedBox(height: 10),
            _settingsCard(
              cardColor: cardColor,
              shadowDarkMode: _darkMode,
              children: [
                _toggleItem(
                  icon: _darkMode
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  iconColor: _darkMode ? tdIconDarkMode : tdIconLightMode,
                  title: 'Dark Mode',
                  subtitle:
                      _darkMode ? 'Dark theme is on' : 'Light theme is on',
                  value: _darkMode,
                  textColor: textColor,
                  subtitleColor: subtitleColor,
                  onChanged: (val) {
                    setState(() => _darkMode = val);
                    _saveSetting('darkMode', val);
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Notifications Section
            _sectionTitle('Notifications', sectionLabelColor),
            const SizedBox(height: 10),
            _settingsCard(
              cardColor: cardColor,
              shadowDarkMode: _darkMode,
              children: [
                _toggleItem(
                  icon: Icons.notifications_rounded,
                  iconColor: tdIconNotifications,
                  title: 'Enable Notifications',
                  subtitle: 'Receive task reminders',
                  value: _notificationsEnabled,
                  textColor: textColor,
                  subtitleColor: subtitleColor,
                  onChanged: (val) async {
                    setState(() => _notificationsEnabled = val);
                    _saveSetting('notificationsEnabled', val);

                    final todos = Hive.box<ToDo>('todos').values.toList();
                    if (val) {
                      await NotificationService.rescheduleAll(todos); // turn ON → reschedule
                    } else {
                      await NotificationService.plugin.cancelAll();   // turn OFF → cancel all
                    }
                  },
                ),
                _divider(dividerColor),              
              ],
            ),

            const SizedBox(height: 20),

            // App Section
            _sectionTitle('App', sectionLabelColor),
            const SizedBox(height: 10),
            _settingsCard(
              cardColor: cardColor,
              shadowDarkMode: _darkMode,
              children: [
                _navigationItem(
                  icon: Icons.info_outline_rounded,
                  iconColor: tdIconInfo,
                  title: 'About',
                  subtitle: 'App info and version',
                  textColor: textColor,
                  subtitleColor: subtitleColor,
                  onTap: () => context.go('/about'),
                ),
                _divider(dividerColor),
                _navigationItem(
                  icon: Icons.delete_sweep_rounded,
                  iconColor: tdIconDelete,
                  title: 'Clear All Tasks',
                  subtitle: 'Delete all tasks permanently',
                  textColor: textColor,
                  subtitleColor: subtitleColor,
                  onTap: () => _showClearDialog(
                      context, bgColor, cardColor, textColor, subtitleColor),
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _showClearDialog(BuildContext context, Color bgColor, Color cardColor,
      Color textColor, Color subtitleColor) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Clear All Todos',
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
        content: Text(
          'Are you sure you want to delete all todos? This cannot be undone.',
          style: TextStyle(color: subtitleColor),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel',
                style: TextStyle(color: tdIconNotifications)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: tdIconDelete,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              try {
                final todoService = TodoService(Hive.box<ToDo>('todos'));
                await todoService.deleteAllTodos();
                Navigator.of(ctx).pop();                      // close dialog
              } catch (e) {
                print('Error clearing todos: $e');
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, Color sectionLabelColor) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: sectionLabelColor,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _settingsCard({
    required List<Widget> children,
    required Color cardColor,
    required bool shadowDarkMode,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(shadowDarkMode ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _toggleItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required Color textColor,
    required Color subtitleColor,
    required Function(bool)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: onChanged == null ? Colors.grey : textColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: subtitleColor),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: tdIconNotifications,
          ),
        ],
      ),
    );
  }

  Widget _navigationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Color textColor,
    required Color subtitleColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: subtitleColor),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: subtitleColor),
          ],
        ),
      ),
    );
  }

  Widget _divider(Color dividerColor) {
    return Divider(height: 1, indent: 72, color: dividerColor);
  } 

  


}
