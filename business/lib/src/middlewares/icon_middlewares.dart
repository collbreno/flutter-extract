import 'package:built_collection/built_collection.dart';
import 'package:business/business.dart';
import 'package:business/src/actions/icon_actions.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:redux/redux.dart';

class FetchIconMiddleware extends MiddlewareClass<AppState> {
  final AppDatabase database;

  FetchIconMiddleware(this.database);

  IconDao get dao => database.iconDao;

  @override
  dynamic call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    if (action is FetchIconAction) {
      try {
        final entity = await dao.getIconById(action.iconId);
        store.dispatch(FetchIconSucceededAction(IconModel.fromEntity(entity)));
        action.onSucceeded?.call();
      } catch (error) {
        action.onFailed?.call(error);
      }
    } else if (action is FetchIconsAction) {
      try {
        final entities = await dao.getAllIcons();
        final icons = BuiltList(entities.map((e) => IconModel.fromEntity(e)));
        store.dispatch(FetchIconsSucceededAction(icons));
        action.onSucceeded?.call();
      } catch (error) {
        action.onFailed?.call(error);
      }
    } else if (action is InsertIconAction) {
      try {
        await dao.insertIcon(action.icon.toEntity());
        action.onSucceeded?.call();
      } catch (error) {
        action.onFailed?.call(error);
      }
    }

    next(action);
  }
}
