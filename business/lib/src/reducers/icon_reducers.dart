import 'package:business/business.dart';
import 'package:business/src/actions/icon_actions.dart';
import 'package:redux/redux.dart';

class IconReducer extends ReducerClass<AppState> {
  @override
  AppState call(AppState state, dynamic action) {
    if (action is FetchIconsSucceededAction) {
      return state.rebuild((s) => s..icons.addAll(action.icons));
    }
    throw Error();
  }
}
