import 'package:business/business.dart';
import 'package:dartz/dartz.dart';

class UpdatePaymentMethodUseCase extends UseCase<void, PaymentMethod> {
  final IPaymentMethodRepository repository;

  UpdatePaymentMethodUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(PaymentMethod paymentMethod) {
    return repository.update(paymentMethod);
  }
}
