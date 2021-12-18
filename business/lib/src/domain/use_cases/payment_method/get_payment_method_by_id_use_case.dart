import 'package:business/business.dart';
import 'package:dartz/dartz.dart';

class GetPaymentMethodByIdUseCase extends FutureUseCase<PaymentMethod, String> {
  final IPaymentMethodRepository repository;

  GetPaymentMethodByIdUseCase(this.repository);

  @override
  Future<Either<Failure, PaymentMethod>> call(String id) {
    return repository.getById(id);
  }
}
