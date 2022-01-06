import 'package:built_value/built_value.dart';
import 'package:business/src/core/entity.dart';
import 'package:flutter/material.dart' hide Builder;

part 'category.g.dart';

abstract class Category implements Built<Category, CategoryBuilder>, Entity {
  @override
  String get id;

  String get name;

  Color get color;

  IconData get icon;

  Category._();

  factory Category({
    required String id,
    required String name,
    required Color color,
    required IconData icon,
  }) = _$Category._;
}
