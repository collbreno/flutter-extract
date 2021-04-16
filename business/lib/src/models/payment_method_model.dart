import 'package:built_value/built_value.dart';
import 'package:flutter/material.dart' hide Builder;
import 'package:infrastructure/infrastructure.dart';

part 'payment_method_model.g.dart';

abstract class PaymentMethodModel implements Built<PaymentMethodModel, PaymentMethodModelBuilder> {
  int get id;
  String get name;
  Color get color;
  int? get iconId;

  PaymentMethodModel._();

  PaymentMethodEntity toEntity() {
    return PaymentMethodEntity(
      id: id,
      name: name,
      color: color.value,
    );
  }

  factory PaymentMethodModel.fromEntity(PaymentMethodEntity entity) {
    return PaymentMethodModel(
      id: entity.id,
      name: entity.name,
      color: Color(entity.color),
      iconId: entity.iconId,
    );
  }

  factory PaymentMethodModel({
    required int id,
    required String name,
    required Color color,
    int? iconId,
  }) = _$PaymentMethodModel._;
}
