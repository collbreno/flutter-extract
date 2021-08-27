import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:infrastructure/infrastructure.dart';

extension SubcategoryModelToEntity on Subcategory {
  SubcategoryEntity toEntity() {
    return SubcategoryEntity(
      id: id,
      color: color.value,
      name: name,
      parentId: parent.id,
      iconName: IconMapper.getIconName(icon),
      iconFamily: IconMapper.getIconFamily(icon),
    );
  }
}

extension SubcategoryEntityToModel on SubcategoryEntity {
  Subcategory toModel(Category category) {
    return Subcategory(
      id: id,
      color: Color(color),
      name: name,
      parent: category,
      icon: IconMapper.getIcon(name: iconName, family: iconFamily),
    );
  }
}
