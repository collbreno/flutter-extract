import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';

abstract class IExpenseRepository {
  Future<FailureOr<List<Expense>>> getAllExpenses();
  Future<FailureOr<Expense>> getExpenseById(String id);
  Future<FailureOr<int>> getTotalSpent();
  Future<FailureOr<void>> insertExpense();
  Future<FailureOr<bool>> updateExpense(Expense expense);
  Future<FailureOr<void>> deleteExpenseWithId(String id);
}
