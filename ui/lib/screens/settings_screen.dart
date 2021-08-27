import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen();

  final moonIcon = Icon(
    Icons.nightlight_round,
    color: Colors.lightBlue[200],
    key: UniqueKey(),
  );

  final sunIcon = Icon(
    Icons.wb_sunny,
    color: Colors.yellow[700],
    key: UniqueKey(),
  );

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text("Configurações"),
          ),
          body: ListView(
            children: [
              ThemeSwitcher(
                builder: (context) => SwitchListTile(
                  secondary: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    child: _buildIcon(context),
                  ),
                  title: Text('Ativar modo escuro'),
                  value: isDarkTheme(context),
                  onChanged: (isDarkMode) => _onChanged(isDarkMode, context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isDarkTheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  void _onChanged(bool isDarkMode, BuildContext context) {
    ThemeSwitcher.of(context)?.changeTheme(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.blue[800],
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      reverseAnimation: !isDarkMode,
    );
  }

  Icon _buildIcon(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? moonIcon : sunIcon;
  }
}
