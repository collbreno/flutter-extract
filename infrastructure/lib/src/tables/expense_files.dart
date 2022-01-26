import 'package:drift/drift.dart';
import 'package:infrastructure/infrastructure.dart';

@DataClassName('ExpenseFileEntity')
class ExpenseFiles extends Table {
  TextColumn get expenseId => text().references(Expenses, #id, onDelete: KeyAction.cascade)();

  TextColumn get filePath => text().withLength(min: 1, max: FILE_PATH_MAX)();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {expenseId, filePath};
}
