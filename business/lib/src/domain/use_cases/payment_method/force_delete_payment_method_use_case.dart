import 'package:business/business.dart';
import 'package:dartz/dartz.dart';

class ForceDeletePaymentMethodUseCase extends FutureUseCase<void, String> {
  final IPaymentMethodRepository repository;

  ForceDeletePaymentMethodUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) {
    return repository.delete(id);
  }
}
