import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';

abstract class IExpenseRepository {
  Future<FailureOr<List<Expense>>> getAllExpenses({ExpenseFilter? filter});
  Future<FailureOr<Expense>> getExpenseById(String id);
  Future<FailureOr<int>> getTotalSpent({ExpenseFilter? filter});
  Future<FailureOr<void>> insertExpense(Expense expense);
  Future<FailureOr<bool>> updateExpense(Expense expense);
  Future<FailureOr<void>> deleteExpenseWithId(String id);
}
