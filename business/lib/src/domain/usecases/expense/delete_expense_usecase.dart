import 'package:business/src/core/_core.dart';
import 'package:dartz/dartz.dart';

class DeleteExpenseUseCase extends UseCase<void, String> {
  DeleteExpenseUseCase();

  @override
  Future<Either<Failure, void>> call(String param) {
    // TODO: Implement use case
    throw UnimplementedError();
  }
}
