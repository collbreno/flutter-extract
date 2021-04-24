import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';
import 'package:uuid/uuid.dart';

class FixtureExpense {
  final _uid = Uuid();

  late final expense1 = ExpensesCompanion(
    id: Value(_uid.v4()),
    description: Value('Oranges and bananas'),
    value: Value(450),
    date: Value(DateTime(2021, 12, 21, 16, 42)),
    paymentMethodId: Value(_uid.v4()),
    subcategoryId: Value(_uid.v4()),
    storeId: Value(_uid.v4()),
    createdAt: Value(DateTime(2021, 12, 14, 15, 22)),
    updatedAt: Value(DateTime(2021, 11, 1, 10, 15)),
  );

  late final expense2 = ExpensesCompanion(
    id: Value(_uid.v4()),
    description: Value('Chocolate cake'),
    value: Value(1200),
    date: Value(DateTime(2021, 3, 30, 11, 17)),
    paymentMethodId: Value(_uid.v4()),
    subcategoryId: Value(_uid.v4()),
    storeId: Value(_uid.v4()),
    createdAt: Value(DateTime(2021, 7, 12, 3, 20)),
    updatedAt: Value(DateTime(2021, 8, 2, 14, 50)),
  );

  late final expense3 = ExpensesCompanion(
    id: Value(_uid.v4()),
    description: Value('Wireless mouse'),
    value: Value(9690),
    date: Value(DateTime(2021, 11, 15, 10, 8)),
    paymentMethodId: Value(_uid.v4()),
    subcategoryId: Value(_uid.v4()),
    storeId: Value(_uid.v4()),
    createdAt: Value(DateTime(2021, 12, 31, 23, 59)),
    updatedAt: Value(DateTime(2021, 1, 1, 1, 1)),
  );
}
