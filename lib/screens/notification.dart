import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/color_theam/color.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late Box _settingsBox;
  bool _darkMode = false;

  // Selected reminder offset in minutes
  int _selectedMinutes = 60; // default: 1 hour before

  // Preset options: label -> minutes
  final List<Map<String, dynamic>> _presets = [
    {'label': '5 min before', 'minutes': 5},
    {'label': '10 min before', 'minutes': 10},
    {'label': '15 min before', 'minutes': 15},
    {'label': '30 min before', 'minutes': 30},
    {'label': '1 hour before', 'minutes': 60},
    {'label': '2 hours before', 'minutes': 120},
    {'label': '3 hours before', 'minutes': 180},
    {'label': '1 day before', 'minutes': 1440},
  ];

  bool _isCustom = false;
  int _customHours = 1;
  int _customMinutes = 0;

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
      final saved = _settingsBox.get('reminderMinutes', defaultValue: 60);
      setState(() {
        _selectedMinutes = saved;
        _darkMode = _settingsBox.get('darkMode', defaultValue: false);
        // Check if it matches a preset
        final match = _presets.any((p) => p['minutes'] == saved);
        _isCustom = !match;
        if (_isCustom) {
          _customHours = saved ~/ 60;
          _customMinutes = saved % 60;
        }
      });
    } catch (e) {
      print('Error loading settings: $e');
    }
  }

  Future<void> _saveReminderTime(int minutes) async {
    await _settingsBox.put('reminderMinutes', minutes);
    setState(() => _selectedMinutes = minutes);
  }

  String _formatReminder(int minutes) {
    if (minutes < 60) return '$minutes min before';
    if (minutes == 60) return '1 hour before';
    if (minutes < 1440) {
      final h = minutes ~/ 60;
      final m = minutes % 60;
      if (m == 0) return '$h hours before';
      return '${h}h ${m}m before';
    }
    final days = minutes ~/ 1440;
    return '$days day${days > 1 ? 's' : ''} before';
  }

  void _showCustomDialog() {
    int tempHours = _customHours;
    int tempMinutes = _customMinutes;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Custom Reminder Time',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Set how long before the task you want to be reminded.',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hours picker
                  Column(
                    children: [
                      const Text('Hours',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _counterButton(
                            icon: Icons.remove,
                            onTap: () {
                              if (tempHours > 0) {
                                setDialogState(() => tempHours--);
                              }
                            },
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEEFF5),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$tempHours',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          _counterButton(
                            icon: Icons.add,
                            onTap: () {
                              if (tempHours < 23) {
                                setDialogState(() => tempHours++);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.only(top: 20, left: 12, right: 12),
                    child: Text(':',
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold)),
                  ),

                  // Minutes picker
                  Column(
                    children: [
                      const Text('Minutes',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _counterButton(
                            icon: Icons.remove,
                            onTap: () {
                              if (tempMinutes > 0) {
                                setDialogState(() => tempMinutes -= 5);
                                if (tempMinutes < 0) tempMinutes = 0;
                              }
                            },
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEEFF5),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              tempMinutes.toString().padLeft(2, '0'),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          _counterButton(
                            icon: Icons.add,
                            onTap: () {
                              if (tempMinutes < 55) {
                                setDialogState(() => tempMinutes += 5);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                final total = (tempHours * 60) + tempMinutes;
                if (total == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please set at least 5 minutes')),
                  );
                  return;
                }
                setState(() {
                  _customHours = tempHours;
                  _customMinutes = tempMinutes;
                  _isCustom = true;
                });
                _saveReminderTime(total);
                Navigator.pop(ctx);
              },
              child: const Text('Set', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _counterButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFF2196F3).withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF2196F3), size: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = getBGColor(_darkMode);
    final textColor = getTextColor(_darkMode);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => context.go('/'),
        ),
        title: Text(
          'Notification',
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
            // Current Selection Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: tdIconNotifications,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: tdIconNotifications.withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.notifications_active_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Reminder',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatReminder(_selectedMinutes),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Presets label
            const Text(
              'Quick Select',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),

            // Preset options
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: List.generate(_presets.length, (index) {
                  final preset = _presets[index];
                  final isSelected =
                      !_isCustom && _selectedMinutes == preset['minutes'];
                  final isLast = index == _presets.length - 1;

                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() => _isCustom = false);
                          _saveReminderTime(preset['minutes']);
                        },
                        borderRadius: BorderRadius.only(
                          topLeft: index == 0
                              ? const Radius.circular(20)
                              : Radius.zero,
                          topRight: index == 0
                              ? const Radius.circular(20)
                              : Radius.zero,
                          bottomLeft:
                              isLast ? const Radius.circular(20) : Radius.zero,
                          bottomRight:
                              isLast ? const Radius.circular(20) : Radius.zero,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF2196F3)
                                      : const Color(0xFFEEEFF5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.timer_rounded,
                                  color:
                                      isSelected ? Colors.white : Colors.grey,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  preset['label'],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? const Color(0xFF2196F3)
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check_circle_rounded,
                                    color: Color(0xFF2196F3), size: 22),
                            ],
                          ),
                        ),
                      ),
                      if (!isLast)
                        const Divider(
                            height: 1, indent: 72, color: Color(0xFFEEEFF5)),
                    ],
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),

            // Custom option
            const Text(
              'Custom',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),

            InkWell(
              onTap: _showCustomDialog,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: _isCustom
                      ? Border.all(color: const Color(0xFF2196F3), width: 2)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: _isCustom
                            ? const Color(0xFF2196F3)
                            : const Color(0xFFEEEFF5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        color: _isCustom ? Colors.white : Colors.grey,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Custom Time',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight:
                                  _isCustom ? FontWeight.w700 : FontWeight.w500,
                              color: _isCustom
                                  ? const Color(0xFF2196F3)
                                  : Colors.black,
                            ),
                          ),
                          Text(
                            _isCustom
                                ? _formatReminder(_selectedMinutes)
                                : 'Set your own reminder time',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      _isCustom
                          ? Icons.check_circle_rounded
                          : Icons.chevron_right_rounded,
                      color: _isCustom ? const Color(0xFF2196F3) : Colors.grey,
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
