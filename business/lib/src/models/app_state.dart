import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:infrastructure/infrastructure.dart';

part 'app_state.g.dart';

abstract class AppState implements Built<AppState, AppStateBuilder> {
  BuiltList<IconEntity> get icons;
  BuiltList<ExpenseEntity> get expenses;
  BuiltList<TagEntity> get tags;
  BuiltList<SubcategoryEntity> get subcategories;
  BuiltList<CategoryEntity> get categories;
  BuiltList<ExpenseTagEntity> get expenseTags;

  AppState._();

  factory AppState({
    BuiltList<IconEntity> icons,
    BuiltList<ExpenseEntity> expenses,
    BuiltList<TagEntity> tags,
    BuiltList<SubcategoryEntity> subcategories,
    BuiltList<CategoryEntity> categories,
    BuiltList<ExpenseTagEntity> expenseTags,
  }) = _$AppState._;
}
