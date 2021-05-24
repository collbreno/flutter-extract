import 'package:built_value/built_value.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:flutter/material.dart' hide Builder;

part 'subcategory.g.dart';

abstract class Subcategory implements Built<Subcategory, SubcategoryBuilder> {
  String get id;
  String get name;
  IconData get icon;
  Category get parent;

  Subcategory._();

  factory Subcategory({
    required String id,
    required String name,
    required IconData icon,
    required Category parent,
  }) = _$Subcategory._;
}
