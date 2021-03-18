import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

class FixturePaymentMethod {
  final paymentMethod1 = PaymentMethodsCompanion(
    id: Value(1),
    color: Value(123),
    iconId: Value(8),
    name: Value('Money'),
  );

  final paymentMethod2 = PaymentMethodsCompanion(
    id: Value(2),
    color: Value(4132),
    iconId: Value(5),
    name: Value('Debit'),
  );

  final paymentMethod3 = PaymentMethodsCompanion(
    id: Value(3),
    color: Value(2344),
    iconId: Value(9),
    name: Value('Credit'),
  );
}
