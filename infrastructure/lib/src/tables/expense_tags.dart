import 'package:moor/moor.dart';

@DataClassName('ExpenseTagEntity')
class ExpenseTags extends Table {
  IntColumn get expenseId => integer().customConstraint('REFERENCES expenses(id)')();

  IntColumn get tagId => integer().customConstraint('REFERENCES tags(id)')();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {expenseId, tagId};
}
