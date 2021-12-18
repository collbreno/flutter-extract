import 'package:business/business.dart';
import 'package:dartz/dartz.dart';

class UpdateExpenseUseCase extends FutureUseCase<bool, Expense> {
  UpdateExpenseUseCase();

  @override
  Future<Either<Failure, bool>> call(Expense param) {
    // TODO: Implement use case
    throw UnimplementedError();
  }
}
