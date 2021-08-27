import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:uuid/uuid.dart';

class FixturePaymentMethod {
  final _uid = Uuid();

  late final paymentMethod1 = PaymentMethod(
    id: _uid.v4(),
    color: Color(Colors.green.value),
    icon: Icons.money,
    name: 'Money',
  );

  late final paymentMethod2 = PaymentMethod(
    id: _uid.v4(),
    color: Color(Colors.deepPurple.value),
    icon: Icons.credit_card,
    name: 'Debit',
  );

  late final paymentMethod3 = PaymentMethod(
    id: _uid.v4(),
    color: Color(Colors.purple.value),
    icon: Icons.credit_card,
    name: 'Credit',
  );
}

extension PM on PaymentMethod {
  PaymentMethodEntity toEntity() {
    return PaymentMethodEntity(
      id: id,
      name: name,
      color: color.value,
      iconFamily: IconMapper.getIconFamily(icon),
      iconName: IconMapper.getIconName(icon),
    );
  }
}
