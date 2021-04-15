import 'package:built_value/built_value.dart';
import 'package:flutter/material.dart' hide Builder;
import 'package:infrastructure/infrastructure.dart';

part 'tag_model.g.dart';

abstract class TagModel implements Built<TagModel, TagModelBuilder> {
  int get id;
  String get name;
  Color get color;
  int get iconId;

  TagModel._();

  TagEntity toEntity() {
    return TagEntity(
      id: id,
      name: name,
      color: color.value,
      iconId: iconId,
    );
  }

  factory TagModel.fromEntity(TagEntity entity) {
    return TagModel(
      id: entity.id,
      name: entity.name,
      color: Color(entity.color),
      iconId: entity.iconId,
    );
  }

  factory TagModel({
    int id,
    String name,
    Color color,
    int iconId,
  }) = _$TagModel._;
}
