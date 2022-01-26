import 'package:drift/drift.dart';
import 'package:infrastructure/infrastructure.dart';

@DataClassName('ExpenseDraftEntity')
class ExpenseDrafts extends Table {
  TextColumn get id => text().withLength(min: UID_SIZE, max: UID_SIZE)();

  TextColumn get description =>
      text().nullable().withLength(min: 1, max: EXPENSE_DESCRIPTION_MAX)();

  IntColumn get value => integer().nullable()();

  DateTimeColumn get date => dateTime().nullable()();

  TextColumn get paymentMethodId => text().nullable().references(PaymentMethods, #id)();

  TextColumn get subcategoryId => text().nullable().references(Subcategories, #id)();

  TextColumn get storeId => text().nullable().references(Stores, #id)();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column>? get primaryKey => {id};
}
