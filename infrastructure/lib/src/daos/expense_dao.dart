import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

part 'expense_dao.g.dart';

@UseDao(tables: [Expenses])
class ExpenseDao extends DatabaseAccessor<AppDatabase> with _$ExpenseDaoMixin {
  final AppDatabase db;

  ExpenseDao(this.db) : super(db);

  Future<List<Expense>> getAllExpenses() {
    return select(expenses).get();
  }

  Future<int> insertExpense(Insertable<Expense> expense) {
    return into(expenses).insert(expense);
  }

  Future<bool> updateExpense(Insertable<Expense> expense) {
    return update(expenses).replace(expense);
  }

  Future<int> deleteExpenseWithId(int id) {
    final query = delete(expenses)..where((e) => e.id.equals(id));
    return query.go();
  }

  Future<Expense> getExpenseWithId(int id) {
    final query = select(expenses)..where((e) => e.id.equals(id));
    return query.getSingle();
  }
}
