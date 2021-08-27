import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:infrastructure/infrastructure.dart';

extension TagModelToEntity on Tag {
  TagEntity toEntity() {
    return TagEntity(
      id: id,
      color: color.value,
      name: name,
      iconName: icon != null ? IconMapper.getIconName(icon!) : null,
      iconFamily: icon != null ? IconMapper.getIconFamily(icon!) : null,
    );
  }
}

extension TagEntityToModel on TagEntity {
  Tag toModel() {
    return Tag(
      id: id,
      color: Color(color),
      name: name,
      icon: iconName != null && iconFamily != null
          ? IconMapper.getIcon(name: iconName!, family: iconFamily!)
          : null,
    );
  }
}
