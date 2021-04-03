import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter/material.dart' hide Builder;

part 'tag.g.dart';

abstract class Tag implements Built<Tag, TagBuilder> {
  static Serializer<Tag> get serializer => _$tagSerializer;

  int get id;
  String get name;
  Color get color;
  IconData get icon;

  Tag._();
  factory Tag({int id, String name, Color color, IconData icon}) = _$Tag._;
}