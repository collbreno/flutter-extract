import 'package:business/business.dart';
import 'package:business/src/actions/icon_actions.dart';
import 'package:business/src/repositories/icon_repository.dart';
import 'package:redux/redux.dart';

class FetchIconMiddleware extends MiddlewareClass<AppState> {
  final IconRepository iconRepository;

  FetchIconMiddleware(this.iconRepository);

  @override
  dynamic call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    if (action is FetchIconAction) {
      try {
        final icon = await iconRepository.getIconFromDatabase(action.iconId);
        store.dispatch(FetchIconSucceededAction(icon));
      } catch (e) {
        store.dispatch(FetchIconFailedAction(e));
      }
    }
  }
}
