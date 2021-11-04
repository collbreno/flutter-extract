import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:dartz/dartz.dart';

class InsertExpenseUseCase extends UseCase<void, Expense> {
  InsertExpenseUseCase();

  @override
  Future<Either<Failure, void>> call(Expense param) {
    // TODO: Implement use case
    throw UnimplementedError();
  }
}
