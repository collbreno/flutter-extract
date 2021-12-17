import 'package:infrastructure/infrastructure.dart';
import 'package:drift/drift.dart';

@DataClassName('ExpenseDraftEntity')
class ExpenseDrafts extends Table {
  TextColumn get id => text().withLength(min: UID_SIZE, max: UID_SIZE)();
  TextColumn get description =>
      text().nullable().withLength(min: 1, max: EXPENSE_DESCRIPTION_MAX)();
  IntColumn get value => integer().nullable()();
  DateTimeColumn get date => dateTime().nullable()();
  TextColumn get paymentMethodId =>
      text().nullable().customConstraint('NULL REFERENCES payment_methods(id)')();
  TextColumn get subcategoryId =>
      text().nullable().customConstraint('NULL REFERENCES subcategories(id)')();
  TextColumn get storeId => text().nullable().customConstraint('NULL REFERENCES stores(id)')();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column>? get primaryKey => {id};
}
