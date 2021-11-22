import 'package:business/business.dart';

abstract class IPaymentMethodRepository {
  Future<FailureOr<List<PaymentMethod>>> getAll();
  Future<FailureOr<PaymentMethod>> getById(String id);
  Future<FailureOr<void>> insert(PaymentMethod paymentMethod);
  Future<FailureOr<void>> update(PaymentMethod paymentMethod);
  Future<FailureOr<void>> delete(String id);
  Future<FailureOr<int>> countUsages(String id);
}
