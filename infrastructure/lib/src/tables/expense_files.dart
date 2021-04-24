import 'package:moor/moor.dart';

@DataClassName('ExpenseFileEntity')
class ExpenseFiles extends Table {
  TextColumn get expenseId => text().customConstraint('REFERENCES expenses(id)')();
  TextColumn get fileId => text().customConstraint('REFERENCES files(id)')();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column> get primaryKey => {expenseId, fileId};
}
