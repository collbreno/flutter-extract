import 'package:infrastructure/infrastructure.dart';
import 'package:drift/drift.dart';

@DataClassName('ExpenseEntity')
class Expenses extends Table {
  TextColumn get id => text().withLength(min: UID_SIZE, max: UID_SIZE)();
  TextColumn get description => text().withLength(min: 1, max: EXPENSE_DESCRIPTION_MAX)();
  IntColumn get value => integer()();
  DateTimeColumn get date => dateTime()();
  TextColumn get paymentMethodId => text().customConstraint('REFERENCES payment_methods(id)')();
  TextColumn get subcategoryId => text().customConstraint('REFERENCES subcategories(id)')();
  TextColumn get storeId => text().nullable().customConstraint('NULL REFERENCES stores(id)')();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column>? get primaryKey => {id};
}
