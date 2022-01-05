import 'package:business/business.dart';

class WatchPaymentMethodsUseCase extends NoParamStreamUseCase<List<PaymentMethod>> {
  final IPaymentMethodRepository repository;

  WatchPaymentMethodsUseCase(this.repository);

  @override
  Stream<FailureOr<List<PaymentMethod>>> call() {
    return repository.watchAll();
  }
}
