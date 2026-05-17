import 'package:flutter/material.dart';

// Primary Colors
const Color tdRed = Color(0xFFDA4040);
const Color tdBlue = Color(0xFF5F52EE);

// Basic Colors
const Color tdBlack = Color(0xFF3A3A3A);
const Color tdGrey = Color(0xFF717171);

// Light Theme Colors
const Color tdBGColor = Color(0xFFEEEFF5);
const Color tdCardColorLight = Colors.white;
const Color tdTextColorLight = Colors.black;
const Color tdSubtitleColorLight = Colors.grey;
const Color tdDividerColorLight = Color(0xFFEEEFF5);
const Color tdSectionLabelColorLight = Colors.grey;

// Dark Theme Colors
const Color tdBGColorDark = Color(0xFF1A1A2E);
const Color tdCardColorDark = Color(0xFF16213E);
const Color tdTextColorDark = Colors.white;
const Color tdSubtitleColorDark = Colors.white54;
const Color tdDividerColorDark = Color(0xFF0F3460);
const Color tdSectionLabelColorDark = Colors.white38;

// Accent Colors for Settings
const Color tdIconNotifications = Color(0xFF2196F3);
const Color tdIconSound = Color(0xFF4CAF50);
const Color tdIconVibration = Color(0xFFFF9800);
const Color tdIconDelete = Color(0xFFE53935);
const Color tdIconDarkMode = Color(0xFF7B68EE);
const Color tdIconLightMode = Color(0xFFFF9800);
const Color tdIconInfo = Color(0xFF2196F3);

// Helper functions to get colors based on dark mode
Color getBGColor(bool isDarkMode) => isDarkMode ? tdBGColorDark : tdBGColor;

Color getCardColor(bool isDarkMode) =>
    isDarkMode ? tdCardColorDark : tdCardColorLight;

Color getTextColor(bool isDarkMode) =>
    isDarkMode ? tdTextColorDark : tdTextColorLight;

Color getSubtitleColor(bool isDarkMode) =>
    isDarkMode ? tdSubtitleColorDark : tdSubtitleColorLight;

Color getDividerColor(bool isDarkMode) =>
    isDarkMode ? tdDividerColorDark : tdDividerColorLight;

Color getSectionLabelColor(bool isDarkMode) =>
    isDarkMode ? tdSectionLabelColorDark : tdSectionLabelColorLight;
