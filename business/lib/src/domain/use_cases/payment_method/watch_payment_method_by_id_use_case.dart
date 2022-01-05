import 'package:business/business.dart';

class WatchPaymentMethodByIdUseCase extends StreamUseCase<PaymentMethod, String> {
  final IPaymentMethodRepository repository;

  WatchPaymentMethodByIdUseCase(this.repository);

  @override
  Stream<FailureOr<PaymentMethod>> call(String id) {
    return repository.watchById(id);
  }
}
