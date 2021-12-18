import 'package:business/business.dart';
import 'package:dartz/dartz.dart';

class GetPaymentMethodsUseCase extends NoParamFutureUseCase<List<PaymentMethod>> {
  final IPaymentMethodRepository repository;

  GetPaymentMethodsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PaymentMethod>>> call() {
    return repository.getAll();
  }
}
