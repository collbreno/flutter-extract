import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:ui/common/app_theme.dart';
import 'package:ui/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      initTheme: AppTheme.initTheme,
      builder: (context, theme) {
        return MaterialApp(
          title: 'Extract',
          theme: theme,
          home: HomeScreen(),
        );
      },
    );
  }
}
