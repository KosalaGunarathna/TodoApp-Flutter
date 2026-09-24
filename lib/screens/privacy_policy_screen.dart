import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/theme/app_colors.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = Hive.isBoxOpen('settings')
        ? Hive.box('settings')
        : await Hive.openBox('settings');
    if (mounted) {
      setState(() => _darkMode = settings.get('darkMode', defaultValue: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    final background = getBGColor(_darkMode);
    final text = getTextColor(_darkMode);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: text),
          onPressed: () => context.go('/'),
        ),
        title: Text(
          'Privacy Policy',
          style: TextStyle(color: text, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _policyCard(
            'Last updated: January 2026',
            'Todo App stores task content locally on your device. This policy explains what the app and its advertising provider may process.',
          ),
          _policyCard(
            'Information stored locally',
            'Tasks, notes, reminder settings, notification preferences, and appearance settings are stored in the app on your device. The developer does not receive this content.',
          ),
          _policyCard(
            'Advertising',
            'Todo App uses Google AdMob. AdMob may process device identifiers, IP address, approximate location, diagnostics, ad interactions, and information used to show or measure ads. The exact data depends on your device, region, consent choices, and Google settings.',
          ),
          _policyCard(
            'Notifications',
            'If you enable reminders, the app schedules notifications on your device. Notification content is generated from your local tasks and is not sent to the developer.',
          ),
          _policyCard(
            'Your choices',
            'You can disable notifications in the app or Android settings. You can manage advertising privacy choices through the controls provided by Google and your device. You can delete locally stored tasks from the app.',
          ),
          _policyCard(
            'Contact',
            'For privacy questions or requests, contact the developer using the support email shown on the Todo App Google Play listing.',
          ),
          _policyCard(
            'Changes',
            'This policy may be updated when the app or its services change. The latest version is available in the app and at the public privacy-policy URL listed on Google Play.',
          ),
        ],
      ),
    );
  }

  Widget _policyCard(String title, String content) {
    final card = getCardColor(_darkMode);
    final text = getTextColor(_darkMode);
    final subtitle = getSubtitleColor(_darkMode);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(fontSize: 14, height: 1.5, color: subtitle),
          ),
        ],
      ),
    );
  }
}
