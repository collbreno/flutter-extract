import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:dartz/dartz.dart';

class UpdateExpenseUseCase extends UseCase<bool, Expense> {
  UpdateExpenseUseCase();

  @override
  Future<Either<Failure, bool>> call(Expense param) {
    // TODO: Implement use case
    throw UnimplementedError();
  }
}
