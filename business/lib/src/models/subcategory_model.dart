import 'package:built_value/built_value.dart';
import 'package:business/src/models/category_model.dart';
import 'package:business/src/models/icon_model.dart';
import 'package:flutter/material.dart' hide Builder;

part 'subcategory_model.g.dart';

abstract class SubcategoryModel implements Built<SubcategoryModel, SubcategoryModelBuilder> {
  int get id;
  String get name;
  AsyncSnapshot<IconModel> get icon;
  AsyncSnapshot<CategoryModel> get category;

  SubcategoryModel._();

  factory SubcategoryModel({
    int id,
    String name,
    AsyncSnapshot<IconModel> icon,
    AsyncSnapshot<CategoryModel> category,
  }) = _$SubcategoryModel._;
}
