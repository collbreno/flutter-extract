import 'package:drift/drift.dart';
import 'package:infrastructure/src/tables/_tables.dart';

@DataClassName('ExpenseTagEntity')
class ExpenseTags extends Table {
  TextColumn get expenseId => text().references(Expenses, #id, onDelete: KeyAction.cascade)();

  TextColumn get tagId => text().references(Tags, #id)();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {expenseId, tagId};
}
