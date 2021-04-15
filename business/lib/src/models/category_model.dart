import 'package:built_value/built_value.dart';
import 'package:infrastructure/infrastructure.dart';

part 'category_model.g.dart';

abstract class CategoryModel implements Built<CategoryModel, CategoryModelBuilder> {
  int get id;
  String get name;
  int get iconId;

  CategoryModel._();

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      iconId: iconId,
    );
  }

  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      iconId: entity.iconId,
      name: entity.name,
    );
  }

  factory CategoryModel({
    int id,
    String name,
    int iconId,
  }) = _$CategoryModel._;
}
