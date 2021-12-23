import 'package:business/business.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Testing orderedRightEquals', () {
    final actual = Right([1, 2, 3, 4]);
    final expected = [1, 2, 3, 4];
    final notExpected = [1, 2, 3];
    final notExpected2 = [1, 2, 4, 3];

    expect(actual, orderedRightEquals(expected));
    expect(actual, isNot(orderedRightEquals(notExpected)));
    expect(actual, isNot(orderedRightEquals(notExpected2)));
  });
}
