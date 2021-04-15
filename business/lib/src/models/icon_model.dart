import 'package:built_value/built_value.dart';
import 'package:business/src/icons/material_icons.dart';
import 'package:flutter/material.dart' hide Builder;
import 'package:infrastructure/infrastructure.dart';

part 'icon_model.g.dart';

abstract class IconModel implements Built<IconModel, IconModelBuilder> {
  int get id;
  IconData get iconData;

  IconModel._();

  IconEntity toEntity() {
    if (iconData.fontFamily == MaterialIconsMapper.family) {
      return IconEntity(
        id: id,
        name: MaterialIconsMapper.map.entries.singleWhere((element) => element.value == iconData).key,
        family: iconData.fontFamily,
      );
    }
    throw Error();
  }

  factory IconModel.fromEntity(IconEntity entity) {
    if (entity.family == MaterialIconsMapper.family) {
      return IconModel(
        id: entity.id,
        iconData: MaterialIconsMapper.map[entity.name],
      );
    }
    throw Error();
  }

  factory IconModel({
    int id,
    IconData iconData,
  }) = _$IconModel._;
}
