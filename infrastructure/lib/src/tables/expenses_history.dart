import 'package:moor/moor.dart';

@DataClassName('ExpenseHistoryEntity')
class ExpensesHistory extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get expenseId => integer()();

  TextColumn get description => text().withLength(min: 1, max: 400)();

  IntColumn get value => integer()();

  DateTimeColumn get date => dateTime()();

  IntColumn get paymentMethodId =>
      integer().customConstraint('REFERENCES payment_methods(id)')();

  IntColumn get subcategoryId =>
      integer().customConstraint('REFERENCES subcategories(id)')();

  IntColumn get storeId =>
      integer().nullable().customConstraint('NULL REFERENCES stores(id)')();

  DateTimeColumn get alteredAt => dateTime()();
}
