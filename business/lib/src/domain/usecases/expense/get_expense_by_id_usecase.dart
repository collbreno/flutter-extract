import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:dartz/dartz.dart';

class GetExpenseByIdUseCase extends UseCase<Expense, String> {
  GetExpenseByIdUseCase();

  @override
  Future<Either<Failure, Expense>> call(String param) {
    // TODO: Implement use case
    throw UnimplementedError();
  }
}
