import 'package:moor/moor.dart';

@DataClassName('ExpenseTagEntity')
class ExpenseTags extends Table {
  TextColumn get expenseId => text().customConstraint('REFERENCES expenses(id)')();
  TextColumn get tagId => text().customConstraint('REFERENCES tags(id)')();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {expenseId, tagId};
}
