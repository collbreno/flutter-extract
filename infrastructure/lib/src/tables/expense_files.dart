import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

@DataClassName('ExpenseFileEntity')
class ExpenseFiles extends Table {
  TextColumn get expenseId =>
      text().customConstraint('REFERENCES expenses(id) ON DELETE CASCADE')();
  TextColumn get filePath => text().withLength(min: 1, max: FILE_PATH_MAX)();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {expenseId, filePath};
}
