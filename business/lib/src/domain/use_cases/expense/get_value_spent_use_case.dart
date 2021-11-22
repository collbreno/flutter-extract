import 'package:business/src/core/_core.dart';
import 'package:dartz/dartz.dart';

class GetValueSpentUseCase extends UseCase<int, ExpenseFilter> {
  GetValueSpentUseCase();

  @override
  Future<Either<Failure, int>> call(ExpenseFilter filter) {
    // TODO: Implement use case
    throw UnimplementedError();
  }
}
