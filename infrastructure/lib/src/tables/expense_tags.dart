import 'package:drift/drift.dart';

@DataClassName('ExpenseTagEntity')
class ExpenseTags extends Table {
  TextColumn get expenseId =>
      text().customConstraint('REFERENCES expenses(id) ON DELETE CASCADE')();
  TextColumn get tagId => text().customConstraint('REFERENCES tags(id)')();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {expenseId, tagId};
}
