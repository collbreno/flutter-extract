import 'package:moor/moor.dart';

@DataClassName('ExpenseEntity')
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get description => text().withLength(min: 1, max: 400)();

  IntColumn get value => integer()();

  DateTimeColumn get date => dateTime()();

  IntColumn get paymentMethodId =>
      integer().customConstraint('REFERENCES payment_methods(id)')();

  IntColumn get subcategoryId =>
      integer().customConstraint('REFERENCES subcategories(id)')();

  IntColumn get storeId =>
      integer().nullable().customConstraint('NULL REFERENCES stores(id)')();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

}
