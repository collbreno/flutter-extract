import 'package:infrastructure/infrastructure.dart';
import 'package:infrastructure/src/tables/expenses_history.dart';
import 'package:moor/moor.dart';

part 'expenses_history_dao.g.dart';

@UseDao(tables: [ExpensesHistory])
class ExpensesHistoryDao extends DatabaseAccessor<AppDatabase> with _$ExpensesHistoryDaoMixin {
  final AppDatabase db;

  ExpensesHistoryDao(this.db) : super(db);

  Future<List<ExpenseHistoryEntity>> getAllExpensesHistory() {
    return select(expensesHistory).get();
  }

}