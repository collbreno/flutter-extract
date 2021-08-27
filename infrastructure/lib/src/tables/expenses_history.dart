import 'package:moor/moor.dart';

@DataClassName('ExpenseHistoryEntity')
class ExpensesHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get expenseId => text()();
  TextColumn get description => text().withLength(min: 1, max: 400)();
  IntColumn get value => integer()();
  DateTimeColumn get date => dateTime()();
  TextColumn get paymentMethodId => text().customConstraint('REFERENCES payment_methods(id)')();
  TextColumn get subcategoryId => text().customConstraint('REFERENCES subcategories(id)')();
  TextColumn get storeId => text().nullable().customConstraint('NULL REFERENCES stores(id)')();
  DateTimeColumn get alteredAt => dateTime()();
}
