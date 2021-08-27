import 'package:infrastructure/infrastructure.dart';
import 'package:uuid/uuid.dart';

class FixtureExpense {
  final _uid = Uuid();

  late final expense1 = ExpenseEntity(
    id: _uid.v4(),
    description: 'Oranges and bananas',
    value: 450,
    date: DateTime(2021, 12, 21, 16, 42),
    paymentMethodId: _uid.v4(),
    subcategoryId: _uid.v4(),
    storeId: _uid.v4(),
    createdAt: DateTime(2021, 12, 14, 15, 22),
    updatedAt: DateTime(2021, 11, 1, 10, 15),
  );

  late final expense2 = ExpenseEntity(
    id: _uid.v4(),
    description: 'Chocolate cake',
    value: 1200,
    date: DateTime(2021, 3, 30, 11, 17),
    paymentMethodId: _uid.v4(),
    subcategoryId: _uid.v4(),
    storeId: _uid.v4(),
    createdAt: DateTime(2021, 7, 12, 3, 20),
    updatedAt: DateTime(2021, 8, 2, 14, 50),
  );

  late final expense3 = ExpenseEntity(
    id: _uid.v4(),
    description: 'Wireless mouse',
    value: 9690,
    date: DateTime(2021, 11, 15, 10, 8),
    paymentMethodId: _uid.v4(),
    subcategoryId: _uid.v4(),
    storeId: _uid.v4(),
    createdAt: DateTime(2021, 12, 31, 23, 59),
    updatedAt: DateTime(2021, 1, 1, 1, 1),
  );
}
