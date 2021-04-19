import 'package:built_collection/built_collection.dart';
import 'package:business/business.dart';
import 'package:business/src/actions/icon_actions.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:redux/redux.dart';

class IconMiddleware extends MiddlewareClass<AppState> {
  final AppDatabase database;

  IconMiddleware(this.database);

  IconDao get dao => database.iconDao;

  @override
  dynamic call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    if (action is FetchIconAction) {
      try {
        final entity = await dao.getIconById(action.iconId);
        if (entity != null) {
          store.dispatch(FetchIconSucceededAction(IconModel.fromEntity(entity)));
          action.onSucceeded?.call();
        } else {
          action.onFailed?.call(Exception()); // TODO: create a exception
        }
      } on Exception catch (e) {
        action.onFailed?.call(e);
      }
    } else if (action is FetchIconsAction) {
      try {
        final entities = await dao.getAllIcons();
        final icons = BuiltList<IconModel>(entities.map((e) => IconModel.fromEntity(e)));
        store.dispatch(FetchIconsSucceededAction(icons));
        action.onSucceeded?.call();
      } on Exception catch (e) {
        action.onFailed?.call(e);
      }
    } else if (action is InsertIconAction) {
      try {
        await dao.insertIcon(action.icon.toEntity());
        action.onSucceeded?.call();
      } on Exception catch (e) {
        action.onFailed?.call(e);
      }
    }

    next(action);
  }
}
