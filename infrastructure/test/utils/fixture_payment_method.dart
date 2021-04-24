import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';
import 'package:uuid/uuid.dart';

class FixturePaymentMethod {
  final _uid = Uuid();

  late final paymentMethod1 = PaymentMethodsCompanion(
    id: Value(_uid.v4()),
    color: Value(324),
    iconId: Value(_uid.v4()),
    name: Value('Money'),
  );

  late final paymentMethod2 = PaymentMethodsCompanion(
    id: Value(_uid.v4()),
    color: Value(345),
    iconId: Value(_uid.v4()),
    name: Value('Debit'),
  );

  late final paymentMethod3 = PaymentMethodsCompanion(
    id: Value(_uid.v4()),
    color: Value(643),
    iconId: Value(_uid.v4()),
    name: Value('Credit'),
  );
}
