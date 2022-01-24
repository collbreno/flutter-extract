import 'package:built_collection/built_collection.dart';
import 'package:business/fixtures.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:uuid/uuid.dart';

class FixtureExpense {
  final _uid = Uuid();
  late final _fixStore = FixtureStore();
  late final _fixTag = FixtureTag();
  late final _fixPaymentMethod = FixturePaymentMethod();
  late final _fixSubcategory = FixtureSubcategory();

  late final expense1 = Expense(
      id: _uid.v4(),
      description: 'Oranges and bananas',
      value: 450,
      date: DateTime(2021, 12, 21, 16, 42),
      paymentMethod: _fixPaymentMethod.paymentMethod1,
      subcategory: _fixSubcategory.subcategory1,
      store: _fixStore.store1,
      createdAt: DateTime(2021, 12, 14, 15, 22),
      updatedAt: DateTime(2021, 11, 1, 10, 15),
      tags: BuiltSet([_fixTag.tag1, _fixTag.tag2]),
      files: BuiltSet(['file1.png', 'file2.png']));

  late final expense2 = Expense(
      id: _uid.v4(),
      description: 'Chocolate cake',
      value: 1200,
      date: DateTime(2021, 3, 30, 11, 17),
      paymentMethod: _fixPaymentMethod.paymentMethod2,
      subcategory: _fixSubcategory.subcategory3,
      store: _fixStore.store2,
      createdAt: DateTime(2021, 7, 12, 3, 20),
      updatedAt: DateTime(2021, 8, 2, 14, 50),
      tags: BuiltSet([_fixTag.tag2]),
      files: BuiltSet(['file3.png']));

  late final expense3 = Expense(
    id: _uid.v4(),
    description: 'Wireless mouse',
    value: 9690,
    date: DateTime(2021, 11, 15, 10, 8),
    paymentMethod: _fixPaymentMethod.paymentMethod1,
    subcategory: _fixSubcategory.subcategory2,
    store: _fixStore.store3,
    createdAt: DateTime(2021, 12, 31, 23, 59),
    updatedAt: DateTime(2021, 1, 1, 1, 1),
    tags: BuiltSet([_fixTag.tag1, _fixTag.tag3]),
    files: BuiltSet(['file4.jpg']),
  );
}
