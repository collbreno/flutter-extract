import 'package:built_collection/built_collection.dart';
import 'package:business/src/models/tag.dart';
import 'package:business/src/redux/state.dart';
import 'package:flutter/material.dart';
import 'package:infrastructure/infrastructure.dart' hide Store, Tag;
import 'package:redux/redux.dart';

class FetchTagsAction {}

class FetchTagsSucceededAction {
  final List<Tag> tags;

  FetchTagsSucceededAction(this.tags);
}

class FetchTagsFailedAction {
  final Exception error;

  FetchTagsFailedAction(this.error);
}

AppState tagsReducer(AppState state, dynamic action) {
  if (action is FetchTagsAction) {
    return AppState(
      tags: AsyncSnapshot.waiting(),
    );
  } else if (action is FetchTagsSucceededAction) {
    return AppState(
      tags: AsyncSnapshot.withData(ConnectionState.done, BuiltList(action.tags)),
    );
  } else if (action is FetchTagsFailedAction) {
    return AppState(
      tags: AsyncSnapshot.withError(ConnectionState.done, action.error),
    );
  }
  return state;
}

class FetchTagsMiddleware extends MiddlewareClass<AppState> {
  final AppDatabase database;

  FetchTagsMiddleware(this.database);

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    if (action is FetchTagsAction) {
      try {
        final fromDB = await database.tagDao.getAllTags();
        final tags = fromDB.map(
          (t) => Tag(
            id: t.id,
            icon: null,
            name: t.name,
            color: Color(t.color),
          ),
        );
        store.dispatch(FetchTagsSucceededAction(tags));
      } catch (error) {
        store.dispatch(FetchTagsFailedAction(error));
      }
    }
  }
}
