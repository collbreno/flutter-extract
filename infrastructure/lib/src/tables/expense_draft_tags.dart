import 'package:drift/drift.dart';

@DataClassName('ExpenseDraftTagEntity')
class ExpenseDraftTags extends Table {
  TextColumn get expenseId =>
      text().customConstraint('REFERENCES expense_drafts(id) ON DELETE CASCADE')();
  TextColumn get tagId => text().customConstraint('REFERENCES tags(id)')();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {expenseId, tagId};
}
