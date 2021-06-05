import 'package:business/src/domain/services/money_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Success cases', () {
    expect(MoneyService.format(1), 'R\$ 0,01');
    expect(MoneyService.format(12), 'R\$ 0,12');
    expect(MoneyService.format(123), 'R\$ 1,23');
    expect(MoneyService.format(1234), 'R\$ 12,34');
    expect(MoneyService.format(12345), 'R\$ 123,45');
    expect(MoneyService.format(123456), 'R\$ 1234,56');
  });
}
