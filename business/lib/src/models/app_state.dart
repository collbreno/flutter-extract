import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:infrastructure/infrastructure.dart';

part 'app_state.g.dart';

abstract class AppState implements Built<AppState, AppStateBuilder> {
  BuiltList<Tag> get tags;

  BuiltList<Subcategory> get subcategories;

  BuiltList<Category> get categories;

  AppState._();

  factory AppState({
    BuiltList<Tag> tags,
    BuiltList<Subcategory> subcategories,
    BuiltList<Category> categories,
  }) = _$AppState._;
}
