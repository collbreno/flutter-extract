import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';

abstract class IPaymentMethodRepository {
  Future<FailureOr<List<PaymentMethod>>> getAll();
  Future<FailureOr<PaymentMethod>> getById(String id);
  Future<FailureOr<void>> insert(PaymentMethod paymentMethod);
  Future<FailureOr<void>> update(PaymentMethod paymentMethod);
  Future<FailureOr<void>> delete(String id);
  Future<FailureOr<int>> countUsages(String id);
}
