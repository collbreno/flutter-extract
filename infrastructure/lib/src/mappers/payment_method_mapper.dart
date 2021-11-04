import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:infrastructure/infrastructure.dart';

extension PaymentMethodModelToEntity on PaymentMethod {
  PaymentMethodEntity toEntity() {
    return PaymentMethodEntity(
      id: id,
      color: color.value,
      name: name,
      iconName: IconMapper.getIconName(icon),
      iconFamily: IconMapper.getIconFamily(icon),
    );
  }
}

extension PaymentMethodEntityToModel on PaymentMethodEntity {
  PaymentMethod toModel() {
    return PaymentMethod(
      id: id,
      color: Color(color),
      name: name,
      icon: IconMapper.getIcon(name: iconName, family: iconFamily),
    );
  }
}
