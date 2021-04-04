import 'package:built_value/built_value.dart';
import 'package:business/src/models/icon_model.dart';
import 'package:flutter/material.dart' hide Builder;

part 'tag_model.g.dart';

abstract class TagModel implements Built<TagModel, TagModelBuilder> {
  int get id;
  String get name;
  Color get color;
  AsyncSnapshot<IconModel> get icon;

  TagModel._();

  factory TagModel({
    int id,
    String name,
    Color color,
    AsyncSnapshot<IconModel> icon,
  }) = _$TagModel._;
}
