import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/color_theam/color.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _notecontroller = TextEditingController();
  DateTime? _date;
  TimeOfDay? _time;

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;
    final bgColor = getBGColor(_darkMode);
    final cardColor = getCardColor(_darkMode);
    final textColor = getTextColor(_darkMode);
    final subtitleColor = getSubtitleColor(_darkMode);

    // Responsive sizing
    final horizontalPadding = isTablet ? screenWidth * 0.12 : 20.0;
    final titleFontSize = isTablet ? 24.0 : 20.0;
    final labelFontSize = isTablet ? 16.0 : 14.0;
    final buttonHeight = isTablet ? 52.0 : 44.0;
    final buttonFontSize = isTablet ? 16.0 : 14.0;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor),
          onPressed: () => context.go('/'),
        ),
        title: Text(
          'Add New Todo',
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Todo Title Field ────────────────────────────────
                      _buildLabel('Your Task', labelFontSize,textColor),
                      const SizedBox(height: 8),
                      _buildInputCard(
                        bgColor: cardColor,
                        textColor: textColor,
                        subtitleColor: subtitleColor,
                        shadowDarkMode: _darkMode,
                        child: TextFormField(
                          controller: _controller,
                          cursorColor: textColor,
                          decoration: InputDecoration(
                            hintText: 'Enter your task...',
                            hintStyle: TextStyle(color: textColor),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: TextStyle(
                            fontSize: 15,
                            color: textColor,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ── Note Field ──────────────────────────────────────
                      _buildLabel('Note', labelFontSize,textColor),
                      const SizedBox(height: 8),
                      _buildInputCard(
                        bgColor: cardColor,
                        textColor: textColor,
                        subtitleColor: subtitleColor,
                        shadowDarkMode: _darkMode,
                        child: TextFormField(
                          controller: _notecontroller,
                          cursorColor: textColor,
                          decoration: InputDecoration(
                            hintText: 'Add a note (optional)',
                            hintStyle: TextStyle(color: textColor),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 15,
                            color: textColor,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ── Date & Time Row (tablet) / Column (mobile) ──────
                      isTablet
                          ? Row(
                              children: [
                                Expanded(child: _buildDateField(labelFontSize, textColor, cardColor)),
                                const SizedBox(width: 16),
                                Expanded(child: _buildTimeField(labelFontSize, textColor, cardColor )),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDateField(labelFontSize, textColor, cardColor),
                                const SizedBox(height: 20),
                                _buildTimeField(labelFontSize, textColor, cardColor),
                              ],
                            ),

                      const Spacer(),
                      const SizedBox(height: 32),

                      // ── Action Buttons ──────────────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: buttonHeight,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                  side: const BorderSide(
                                      color: Colors.blue, width: 1.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  textStyle: TextStyle(
                                    fontSize: buttonFontSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () {
                                  if (context.canPop()) {
                                    context.pop();
                                  } else {
                                    context.go('/');
                                  }
                                },
                                child: const Text('Cancel'),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: buttonHeight,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  textStyle: TextStyle(
                                    fontSize: buttonFontSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () {
                                  if (_controller.text.isEmpty) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          title: const Text(
                                            'Required',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          content: const Text(
                                              'Please enter a your task.'),
                                          actions: [
                                            TextButton(
                                              child: const Text('OK'),
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    return;
                                  }
                                  Navigator.pop(context, {
                                    'todoText': _controller.text,
                                    'todoNote': _notecontroller.text,
                                    'date': _date,
                                    'time': _time,
                                  });
                                },
                                child: const Text('Add Todo'),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                          height: MediaQuery.of(context).viewInsets.bottom > 0
                              ? 16
                              : 8),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLabel(String text, double fontSize,textColor) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: textColor,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildInputCard({
    required Color bgColor,
    required Color textColor,
    required Color subtitleColor,
    required bool shadowDarkMode,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

      Widget _buildDateField(double labelFontSize,Color textColor,Color cardColor,) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('Date', labelFontSize, textColor),
          const SizedBox(height: 8),

          GestureDetector(
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2024),
                lastDate: DateTime(2100),

                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: _darkMode
                        ? ColorScheme.dark(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                        surface: cardColor,
                        onSurface: textColor,     
                        onSecondaryContainer: Colors.white,
                      )
                    : ColorScheme.light(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                        surface: cardColor,
                        onSurface: textColor,  
                        onSecondaryContainer: Colors.white,
                      ),

                    inputDecorationTheme:  InputDecorationTheme(
                      hintStyle: TextStyle(color: textColor),
                      labelStyle: TextStyle(color: textColor),
                    ),

                    textTheme: TextTheme(
                      bodyMedium: TextStyle(color: textColor),
                      bodyLarge: TextStyle(color: textColor),
                    ),

                    datePickerTheme: DatePickerThemeData(
                    inputDecorationTheme: InputDecorationTheme(
                      hintStyle: TextStyle(color: textColor),
                      labelStyle: TextStyle(color: textColor),
                      helperStyle: TextStyle(color: textColor),
                    ),
                  ),

                    ),child: child!,
                  );
                },
              );

              if (pickedDate != null) {
                setState(() {
                  _date = pickedDate;
                });
              }
            },

            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),

              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Text(
                _date == null
                    ? 'Select date'
                    : '${_date!.day}/${_date!.month}/${_date!.year}',

                style: TextStyle(color: textColor),
              ),
            ),
          ),
        ],
      );
    }

    Widget _buildTimeField(double labelFontSize,Color textColor,Color cardColor,)
   {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Time', labelFontSize, textColor),
        const SizedBox(height: 8),

        GestureDetector(
          onTap: () async {
            final pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),

              builder: (context, child) {
                return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: _darkMode
                  ? ColorScheme.dark(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      surface: cardColor,
                      onSurface: textColor,
                      tertiaryContainer: Colors.blue,      // ← AM/PM selected background
                      onTertiaryContainer: Colors.white,   // ← AM/PM selected text
                      secondaryContainer: Colors.blue,     // ← fallback
                      onSecondaryContainer: Colors.white,
                    )
                  : ColorScheme.light(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      surface: cardColor,
                      onSurface: textColor,
                      tertiaryContainer: Colors.blue,      // ← AM/PM selected background
                      onTertiaryContainer: Colors.white,   // ← AM/PM selected text
                      secondaryContainer: Colors.blue,     // ← fallback
                      onSecondaryContainer: Colors.white,
                    ),

                    inputDecorationTheme:  InputDecorationTheme(
                      hintStyle: TextStyle(color: textColor),
                      labelStyle: TextStyle(color: textColor),
                    ),

                    textTheme: TextTheme(
                      bodyMedium: TextStyle(color: textColor),
                    ),
                   
                  ),

                  child: child!,
                );
              },
            );

            if (pickedTime != null) {
              setState(() {
                _time = pickedTime;
              });
            }
          },

          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),

            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
            ),

            child: Text(
              _time == null
                  ? 'Select time'
                  : _time!.format(context),

              style: TextStyle(color: textColor),
            ),
          ),
        ),
      ],
    );
  }
}
