import 'package:business/business.dart';
import 'package:dartz/dartz.dart';

class GetAllPaymentMethodsUseCase extends NoParamUseCase<List<PaymentMethod>> {
  final IPaymentMethodRepository repository;

  GetAllPaymentMethodsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PaymentMethod>>> call() {
    return repository.getAllPaymentMethods();
  }
}
