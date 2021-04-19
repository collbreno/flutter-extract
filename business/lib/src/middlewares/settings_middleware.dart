import 'package:business/business.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';

class SettingsMiddleware extends MiddlewareClass<AppState> {
  @override
  dynamic call(Store<AppState> store, dynamic action, NextDispatcher next) {
    if (action is ToggleBrightnessAction) {
      final newBrightness =
          store.state.brightness == Brightness.dark ? Brightness.light : Brightness.dark;
      store.dispatch(SetBrightnessAction(newBrightness));
    }

    next(action);
  }
}
