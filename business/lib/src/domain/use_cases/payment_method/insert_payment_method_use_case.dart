import 'package:business/business.dart';
import 'package:dartz/dartz.dart';

class InsertPaymentMethodUseCase extends UseCase<void, PaymentMethod> {
  final IPaymentMethodRepository repository;

  InsertPaymentMethodUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(PaymentMethod paymentMethod) {
    return repository.insert(paymentMethod);
  }
}
