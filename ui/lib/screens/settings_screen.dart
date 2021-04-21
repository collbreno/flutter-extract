import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback changeBrightnessCallback;
  final Brightness brightness;

  SettingsScreen({
    required this.changeBrightnessCallback,
    required this.brightness,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            secondary: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: _buildIcon(),
            ),
            title: Text('Ativar modo escuro'),
            value: widget.brightness == Brightness.dark,
            onChanged: _onChanged,
          ),
        ],
      ),
    );
  }

  void _onChanged(bool _) {
    widget.changeBrightnessCallback();
  }

  Icon _buildIcon() {
    return Theme.of(context).brightness == Brightness.dark ? moonIcon : sunIcon;
  }
}
