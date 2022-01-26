import 'package:drift/drift.dart';
import 'package:infrastructure/infrastructure.dart';

@DataClassName('ExpenseHistoryEntity')
class ExpensesHistory extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get expenseId => text()();

  TextColumn get description => text().withLength(min: 1, max: 400)();

  IntColumn get value => integer()();

  DateTimeColumn get date => dateTime()();

  TextColumn get paymentMethodId => text().references(PaymentMethods, #id)();

  TextColumn get subcategoryId => text().references(Subcategories, #id)();

  TextColumn get storeId => text().nullable().references(Stores, #id)();

  DateTimeColumn get alteredAt => dateTime()();
}
