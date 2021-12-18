import 'package:business/business.dart';
import 'package:dartz/dartz.dart';

class GetExpenseByIdUseCase extends FutureUseCase<Expense, String> {
  GetExpenseByIdUseCase();

  @override
  Future<Either<Failure, Expense>> call(String param) {
    // TODO: Implement use case
    throw UnimplementedError();
  }
}
