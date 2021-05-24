import 'package:business/src/domain/entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FixturePaymentMethod {
  final _uid = Uuid();

  late final paymentMethod1 = PaymentMethod(
    id: _uid.v4(),
    color: Colors.green,
    icon: Icons.money,
    name: 'Money',
  );

  late final paymentMethod2 = PaymentMethod(
    id: _uid.v4(),
    color: Colors.purple,
    icon: Icons.credit_card,
    name: 'Debit',
  );

  late final paymentMethod3 = PaymentMethod(
    id: _uid.v4(),
    color: Colors.purple,
    icon: Icons.credit_card,
    name: 'Credit',
  );
}
