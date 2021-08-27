import 'package:business/business.dart';
import 'package:dartz/dartz.dart';

class SafeDeletePaymentMethodUseCase extends UseCase<void, String> {
  final IPaymentMethodRepository repository;

  SafeDeletePaymentMethodUseCase(this.repository);
  @override
  Future<Either<Failure, void>> call(String id) async {
    final usages = await repository.countUsages(id);
    return usages.fold(
      (failure) => Left(failure),
      (usages) => _handleUsages(id, usages),
    );
  }

  Future<FailureOr<void>> _handleUsages(String id, int usages) async {
    if (usages > 0) {
      return Left(EntityBeingUsedFailure(usages));
    } else {
      return await repository.deletePaymentMethodWithId(id);
    }
  }
}
