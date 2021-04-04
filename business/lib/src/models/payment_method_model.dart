import 'package:built_value/built_value.dart';
import 'package:business/src/models/icon_model.dart';
import 'package:flutter/material.dart' hide Builder;

part 'payment_method_model.g.dart';

abstract class PaymentMethodModel implements Built<PaymentMethodModel, PaymentMethodModelBuilder> {
  int get id;
  String get name;
  Color get color;
  AsyncSnapshot<IconModel> get icon;

  PaymentMethodModel._();

  factory PaymentMethodModel({
    int id,
    String name,
    Color color,
    AsyncSnapshot<IconModel> icon,
  }) = _$PaymentMethodModel._;
}
