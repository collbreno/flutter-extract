import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:infrastructure/infrastructure.dart';

extension CategoryModelToEntity on Category {
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      color: color.value,
      name: name,
      iconName: IconMapper.getIconName(icon),
      iconFamily: IconMapper.getIconFamily(icon),
    );
  }
}

extension CategoryEntityToModel on CategoryEntity {
  Category toModel() {
    return Category(
      id: id,
      color: Color(color),
      name: name,
      icon: IconMapper.getIcon(name: iconName, family: iconFamily),
    );
  }
}
