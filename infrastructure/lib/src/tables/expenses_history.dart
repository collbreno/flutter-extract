import 'package:moor/moor.dart';
import '../helpers/builder_extensions.dart';

@DataClassName('ExpenseHistory')
class ExpensesHistory extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get alteredAt => dateTime()();

  IntColumn get expenseId => integer().references('expenses(id)')();

  DateTimeColumn get date => dateTime()();

  IntColumn get paymentMethodId =>
      integer().references(' payment_methods(id)')();

  IntColumn get subcategoryId =>
      integer().references(' subcategories(id)')();

  IntColumn get storeId =>
      integer().nullable().customConstraint('NULL REFERENCES stores(id)')();
}
