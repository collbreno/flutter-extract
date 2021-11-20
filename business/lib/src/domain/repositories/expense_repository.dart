import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';

abstract class IExpenseRepository {
  Future<FailureOr<List<Expense>>> getAll({ExpenseFilter? filter});
  Future<FailureOr<Expense>> getById(String id);
  Future<FailureOr<int>> getTotalSpent({ExpenseFilter? filter});
  Future<FailureOr<void>> insert(Expense expense);
  Future<FailureOr<void>> update(Expense expense);
  Future<FailureOr<void>> delete(String id);
}
