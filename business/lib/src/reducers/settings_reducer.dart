import 'package:business/business.dart';
import 'package:redux/redux.dart';

class SettingsReducer extends ReducerClass<AppState> {
  @override
  AppState call(AppState state, dynamic action) {
    if (action is SetBrightnessAction) {
      print('oi 2');
      return state.rebuild((s) => s..brightness = action.brightness);
    } else {
      return state;
    }
  }
}
