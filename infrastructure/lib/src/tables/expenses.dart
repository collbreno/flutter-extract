import 'package:drift/drift.dart';
import 'package:infrastructure/infrastructure.dart';

@DataClassName('ExpenseEntity')
class Expenses extends Table {
  TextColumn get id => text().withLength(min: UID_SIZE, max: UID_SIZE)();

  TextColumn get description => text().withLength(min: 1, max: EXPENSE_DESCRIPTION_MAX)();

  IntColumn get value => integer()();

  DateTimeColumn get date => dateTime()();

  TextColumn get paymentMethodId => text().references(PaymentMethods, #id)();

  TextColumn get subcategoryId => text().references(Subcategories, #id)();

  TextColumn get storeId => text().nullable().references(Stores, #id)();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column>? get primaryKey => {id};
}
