import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:business/business.dart';

part 'app_state.g.dart';

abstract class AppState implements Built<AppState, AppStateBuilder> {
  BuiltList<IconModel> get icons;
  BuiltList<ExpenseModel> get expenses;
  BuiltList<TagModel> get tags;
  BuiltList<SubcategoryModel> get subcategories;
  BuiltList<CategoryModel> get categories;
  BuiltMap<int, BuiltList<int>> get expenseTags;

  AppState._();

  factory AppState({
    required BuiltList<IconModel> icons,
    required BuiltList<ExpenseModel> expenses,
    required BuiltList<TagModel> tags,
    required BuiltList<SubcategoryModel> subcategories,
    required BuiltList<CategoryModel> categories,
    required BuiltMap<int, BuiltList<int>> expenseTags,
  }) = _$AppState._;
}
