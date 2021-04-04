import 'package:built_value/built_value.dart';
import 'package:business/src/models/icon_model.dart';
import 'package:flutter/material.dart' hide Builder;

part 'category_model.g.dart';

abstract class CategoryModel implements Built<CategoryModel, CategoryModelBuilder> {
  int get id;
  String get name;
  AsyncSnapshot<IconModel> get icon;

  CategoryModel._();

  factory CategoryModel({
    int id,
    String name,
    AsyncSnapshot<IconModel> icon,
  }) = _$CategoryModel._;
}
