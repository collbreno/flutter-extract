import 'package:business/business.dart';
import 'package:dartz/dartz.dart';

class UpdatePaymentMethodUseCase extends UseCase<bool, PaymentMethod> {
  final IPaymentMethodRepository repository;

  UpdatePaymentMethodUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(PaymentMethod paymentMethod) {
    return repository.updatePaymentMethod(paymentMethod);
  }
}
