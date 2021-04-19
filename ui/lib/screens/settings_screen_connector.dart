import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ui/screens/settings_screen.dart';

class SettingsScreenConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        changeBrightnessCallback: () => store.dispatch(ToggleBrightnessAction()),
        brightness: store.state.brightness,
      ),
      distinct: true,
      builder: (context, viewModel) {
        return SettingsScreen(
          brightness: viewModel.brightness,
          changeBrightnessCallback: viewModel.changeBrightnessCallback,
        );
      },
    );
  }
}

class _ViewModel {
  final VoidCallback changeBrightnessCallback;
  final Brightness brightness;

  _ViewModel({
    required this.changeBrightnessCallback,
    required this.brightness,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel && runtimeType == other.runtimeType && brightness == other.brightness;

  @override
  int get hashCode => brightness.hashCode;
}
