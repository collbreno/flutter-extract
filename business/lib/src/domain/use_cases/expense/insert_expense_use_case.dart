import 'package:business/business.dart';
import 'package:dartz/dartz.dart';

class InsertExpenseUseCase extends FutureUseCase<void, Expense> {
  InsertExpenseUseCase();

  @override
  Future<Either<Failure, void>> call(Expense param) {
    // TODO: Implement use case
    throw UnimplementedError();
  }
}
