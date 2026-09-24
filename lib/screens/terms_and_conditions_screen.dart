import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/theme/app_colors.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
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

  @override
  Widget build(BuildContext context) {
    final bgColor = getBGColor(_darkMode);
    final cardColor = getCardColor(_darkMode);
    final textColor = getTextColor(_darkMode);
    final subtitleColor = getSubtitleColor(_darkMode);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => context.go('/settings'),
        ),
        title: Text(
          'Terms & Conditions',
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
          children: [
            const SizedBox(height: 10),

            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: _darkMode ? 0.3 : 0.05,
                    ),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.policy_rounded,
                      color: Color(0xFF2196F3),
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Terms & Conditions',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Last updated: January 2026',
                    style: TextStyle(fontSize: 13, color: subtitleColor),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'These are the simple rules for using Todo App. By using the app, you agree to these terms.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: subtitleColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _sectionCard(
              icon: Icons.waving_hand_rounded,
              title: 'Welcome',
              content: 'Thank you for using Todo App! This app helps you organize your daily tasks and set reminders so you never forget anything important. By using the app, you agree to these simple terms.',
              cardColor: cardColor,
              textColor: textColor,
              subtitleColor: subtitleColor,
              darkMode: _darkMode,
            ),

            const SizedBox(height: 16),

            _sectionCard(
              icon: Icons.phone_android_rounded,
              title: 'How You Can Use the App',
              content: 'Todo App is free to use for personal daily task management. Please use it responsibly and only for its intended purpose — organizing your tasks and reminders.',
              cardColor: cardColor,
              textColor: textColor,
              subtitleColor: subtitleColor,
              darkMode: _darkMode,
            ),

            const SizedBox(height: 16),

            _sectionCard(
              icon: Icons.lock_outline_rounded,
              title: 'Your Tasks Stay Local',
              content: 'Your tasks, notes, and settings are stored locally on your device. The app does not provide an account or upload your task content to our servers. Advertising services may process limited device and usage data as described in the Privacy Policy.',
              cardColor: cardColor,
              textColor: textColor,
              subtitleColor: subtitleColor,
              darkMode: _darkMode,
            ),

            const SizedBox(height: 16),

            _sectionCard(
              icon: Icons.notifications_rounded,
              title: 'Reminders & Notifications',
              content: 'The app can send you reminders on your phone to help you stay on track. You can turn these on or off anytime from the app settings or your phone settings — it\'s totally up to you.',
              cardColor: cardColor,
              textColor: textColor,
              subtitleColor: subtitleColor,
              darkMode: _darkMode,
            ),

            const SizedBox(height: 16),

            _sectionCard(
              icon: Icons.ads_click_rounded,
              title: 'Ads in the App',
              content: 'Todo App uses Google AdMob to display ads. Google may process information such as advertising identifiers, approximate location, diagnostics, and ad interactions. See the Privacy Policy and Google\'s privacy information for details.',
              cardColor: cardColor,
              textColor: textColor,
              subtitleColor: subtitleColor,
              darkMode: _darkMode,
            ),

            const SizedBox(height: 16),

            _sectionCard(
              icon: Icons.update_rounded,
              title: 'App Updates',
              content: 'We may update the app from time to time to add new features or fix issues. We may also update these terms occasionally. We\'ll always try to make the app better for you.',
              cardColor: cardColor,
              textColor: textColor,
              subtitleColor: subtitleColor,
              darkMode: _darkMode,
            ),

            const SizedBox(height: 16),

            _sectionCard(
              icon: Icons.info_outline_rounded,
              title: 'Good to Know',
              content: 'We do our best to make sure the app works well at all times. However, we recommend not relying solely on this app for very important reminders. Always double-check critical tasks.',
              cardColor: cardColor,
              textColor: textColor,
              subtitleColor: subtitleColor,
              darkMode: _darkMode,
            ),

            const SizedBox(height: 16),

            // Contact Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: _darkMode ? 0.3 : 0.05,
                    ),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.mail_outline_rounded,
                      color: Color(0xFF2196F3),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Have a question?',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'We\'d love to hear from you!\ntechwithk9@gmail.com',
                          style: TextStyle(
                            fontSize: 13,
                            color: subtitleColor,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              '© 2026 Todo App. All rights reserved.',
              style: TextStyle(fontSize: 12, color: subtitleColor),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required String content,
    required Color cardColor,
    required Color textColor,
    required Color subtitleColor,
    required bool darkMode,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: darkMode ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: const Color(0xFF2196F3), size: 22),
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
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 13,
                    color: subtitleColor,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
