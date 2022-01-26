import 'package:drift/drift.dart';
import 'package:infrastructure/infrastructure.dart';

@DataClassName('ExpenseDraftTagEntity')
class ExpenseDraftTags extends Table {
  TextColumn get expenseId => text().references(ExpenseDrafts, #id, onDelete: KeyAction.cascade)();

  TextColumn get tagId => text().references(Tags, #id)();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {expenseId, tagId};
}
