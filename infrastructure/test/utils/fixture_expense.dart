import 'package:moor/moor.dart';
import 'package:infrastructure/infrastructure.dart';

class FixtureExpense {
  final expense1 = ExpensesCompanion(
    id: Value(1),
    description: Value('Oranges and bananas'),
    value: Value(450),
    date: Value(DateTime(2021, 12, 21, 16, 42)),
    paymentMethodId: Value(2),
    subcategoryId: Value(6),
    storeId: Value(32),
    createdAt: Value(DateTime(2021, 12, 14, 15, 22)),
    updatedAt: Value(DateTime(2021, 11, 1, 10, 15)),
  );

  final expense2 = ExpensesCompanion(
    id: Value(2),
    description: Value('Chocolate cake'),
    value: Value(1200),
    date: Value(DateTime(2021, 3, 30, 11, 17)),
    paymentMethodId: Value(1),
    subcategoryId: Value(5),
    storeId: Value(27),
    createdAt: Value(DateTime(2021, 7, 12, 3, 20)),
    updatedAt: Value(DateTime(2021, 8, 2, 14, 50)),
  );

  final expense3 = ExpensesCompanion(
    id: Value(3),
    description: Value('Wireless mouse'),
    value: Value(9690),
    date: Value(DateTime(2021, 11, 15, 10, 8)),
    paymentMethodId: Value(4),
    subcategoryId: Value(8),
    storeId: Value(15),
    createdAt: Value(DateTime(2021, 12, 31, 23, 59)),
    updatedAt: Value(DateTime(2021, 1, 1, 1, 1)),
  );
}
