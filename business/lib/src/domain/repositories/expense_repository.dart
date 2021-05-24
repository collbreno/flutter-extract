import 'package:business/src/core/core.dart';
import 'package:business/src/domain/entities/entities.dart';

abstract class IExpenseRepository {
  Future<FailureOr<List<Expense>>> getAllExpenses();
  Future<FailureOr<Expense>> getExpenseById(String id);
  Future<FailureOr<int>> getTotalSpent();
  Future<FailureOr<void>> insertExpense();
  Future<FailureOr<bool>> updateExpense(Expense expense);
  Future<FailureOr<void>> deleteExpenseWithId(String id);
}
