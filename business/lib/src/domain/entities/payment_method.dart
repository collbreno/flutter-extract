import 'package:built_value/built_value.dart';
import 'package:business/src/core/_core.dart';
import 'package:flutter/material.dart' hide Builder;

part 'payment_method.g.dart';

abstract class PaymentMethod implements Built<PaymentMethod, PaymentMethodBuilder>, Entity {
  @override
  String get id;

  String get name;

  Color get color;

  IconData get icon;

  PaymentMethod._();

  factory PaymentMethod({
    required String id,
    required String name,
    required Color color,
    required IconData icon,
  }) = _$PaymentMethod._;
}
