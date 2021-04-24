import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

part 'expense_dao.g.dart';

@UseDao(tables: [Expenses])
class ExpenseDao extends DatabaseAccessor<AppDatabase> with _$ExpenseDaoMixin {
  final AppDatabase db;

  ExpenseDao(this.db) : super(db);

  Future<List<ExpenseEntity>> getAllExpenses() {
    return select(expenses).get();
  }

  Future<ExpenseEntity?> getExpenseById(String id) {
    final query = select(expenses)..where((e) => e.id.equals(id));
    return query.getSingleOrNull();
  }

  Future<int> insertExpense(Insertable<ExpenseEntity> expense) {
    return into(expenses).insert(expense);
  }

  Future<bool> updateExpense(Insertable<ExpenseEntity> expense) {
    return update(expenses).replace(expense);
  }

  Future<int> deleteExpenseWithId(String id) {
    final query = delete(expenses)..where((e) => e.id.equals(id));
    return query.go();
  }
}
