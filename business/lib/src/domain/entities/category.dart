import 'package:built_value/built_value.dart';
import 'package:flutter/material.dart' hide Builder;

part 'category.g.dart';

abstract class Category implements Built<Category, CategoryBuilder> {
  String get id;
  String get name;
  IconData get icon;

  Category._();

  factory Category({
    required String id,
    required String name,
    required IconData icon,
  }) = _$Category._;
}