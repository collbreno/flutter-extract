import 'package:built_value/built_value.dart';
import 'package:infrastructure/infrastructure.dart';

part 'subcategory_model.g.dart';

abstract class SubcategoryModel implements Built<SubcategoryModel, SubcategoryModelBuilder> {
  int get id;
  String get name;
  int get iconId;
  int get parentId;

  SubcategoryModel._();

  SubcategoryEntity toEntity() {
    return SubcategoryEntity(
      id: id,
      name: name,
      iconId: iconId,
      parentId: parentId,
    );
  }

  factory SubcategoryModel.fromEntity(SubcategoryEntity entity) {
    return SubcategoryModel(
      name: entity.name,
      iconId: entity.iconId,
      id: entity.id,
      parentId: entity.parentId,
    );
  }

  factory SubcategoryModel({
    required int id,
    required String name,
    required int iconId,
    required int parentId,
  }) = _$SubcategoryModel._;
}
