import 'package:business/fixtures.dart';
import 'package:infrastructure/src/mappers/payment_method_mapper.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final fix = FixturePaymentMethod();

  test('Payment Method mapper', () async {
    final model = fix.paymentMethod1;
    expect(model, model.toEntity().toModel());
  });
}
