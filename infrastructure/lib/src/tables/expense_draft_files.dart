import 'package:drift/drift.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:infrastructure/src/tables/expense_drafts.dart';

@DataClassName('ExpenseDraftFileEntity')
class ExpenseDraftFiles extends Table {
  TextColumn get expenseId => text().references(ExpenseDrafts, #id, onDelete: KeyAction.cascade)();

  TextColumn get filePath => text().withLength(min: 1, max: FILE_PATH_MAX)();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {expenseId, filePath};
}
