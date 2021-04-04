import 'package:built_value/built_value.dart';
import 'package:flutter/material.dart' hide Builder;

part 'icon_model.g.dart';

abstract class IconModel implements Built<IconModel, IconModelBuilder> {
  int get id;
  IconData get iconData;

  IconModel._();

  factory IconModel({
    int id,
    IconData iconData,
  }) = _$IconModel._;
}
