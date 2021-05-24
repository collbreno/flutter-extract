import 'package:built_value/built_value.dart';
import 'package:flutter/material.dart' hide Builder;

part 'tag.g.dart';

abstract class Tag implements Built<Tag, TagBuilder> {
  String get id;
  String get name;
  Color get color;
  IconData? get icon;

  Tag._();

  factory Tag({
    required String id,
    required String name,
    required Color color,
    IconData? icon,
  }) = _$Tag._;
}
