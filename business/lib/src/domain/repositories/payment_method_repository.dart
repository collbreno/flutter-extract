import 'package:business/src/core/core.dart';
import 'package:business/src/domain/entities/entities.dart';

abstract class IPaymentMethodRepository {
  Future<FailureOr<List<PaymentMethod>>> getAllPaymentMethods();
  Future<FailureOr<PaymentMethod>> getPaymentMethodById(String id);
  Future<FailureOr<void>> insertPaymentMethod(PaymentMethod paymentMethod);
  Future<FailureOr<bool>> updatePaymentMethod(PaymentMethod paymentMethod);
  Future<FailureOr<void>> deletePaymentMethodWithId(String id);
}
