import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:dartz/dartz.dart';

class GetExpensesUseCase extends UseCase<List<Expense>, ExpenseFilter> {
  GetExpensesUseCase();

  @override
  Future<Either<Failure, List<Expense>>> call(ExpenseFilter filter) {
    // TODO: Implement use case
    throw UnimplementedError();
  }
}
