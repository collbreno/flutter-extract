import 'package:moor/moor.dart';
import '../helpers/builder_extensions.dart';

class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get description => text().withLength(min: 1, max: 400)();

  IntColumn get value => integer()();

  DateTimeColumn get date => dateTime()();

  IntColumn get paymentMethodId =>
      integer().references(' payment_methods(id)')();

  IntColumn get subcategoryId =>
      integer().references(' subcategories(id)')();

  IntColumn get storeId =>
      integer().nullable().customConstraint('NULL REFERENCES stores(id)')();
}
