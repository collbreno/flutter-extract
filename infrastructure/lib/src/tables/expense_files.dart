import 'package:moor/moor.dart';

class ExpenseFiles extends Table {
  IntColumn get expenseId =>
      integer().customConstraint('REFERENCES expenses(id)')();

  IntColumn get fileId => integer().customConstraint('REFERENCES files(id)')();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {expenseId, fileId};
}