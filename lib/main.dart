import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/translator_screen.dart';

void main() {
  runApp(const SignLanguageTranslatorApp());
}

class SignLanguageTranslatorApp extends StatelessWidget {
  const SignLanguageTranslatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TertiaLearn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppTheme.background,
        primaryColor: AppTheme.surface,
        fontFamily: 'Roboto',
        useMaterial3: true,
        iconTheme: const IconThemeData(color: Colors.white70),
        colorScheme: const ColorScheme.dark(
          primary: AppTheme.accent,
          surface: AppTheme.surface,
          onSurface: AppTheme.textPrimary,
        ),
      ),
      home: const TranslatorScreen(),
    );
  }
}