import 'package:moor/moor.dart';
import '../helpers/builder_extensions.dart';

class ExpenseTags extends Table {
  IntColumn get expenseId =>
      integer().references(' expenses(id)')();

  IntColumn get tagId => integer().references(' tags(id)')();

  @override
  Set<Column> get primaryKey => {expenseId, tagId};
}
