import 'package:built_value/built_value.dart';
import 'package:flutter/material.dart' hide Builder;

part 'icon.g.dart';

abstract class Icon implements Built<Icon, IconBuilder> {
  String get id;
  IconData get iconData;

  Icon._();

  factory Icon({
    required String id,
    required IconData iconData,
  }) = _$Icon._;
}
