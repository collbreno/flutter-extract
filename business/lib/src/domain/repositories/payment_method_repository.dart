import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';

abstract class IPaymentMethodRepository {
  Future<FailureOr<List<PaymentMethod>>> getAllPaymentMethods();
  Future<FailureOr<PaymentMethod>> getPaymentMethodById(String id);
  Future<FailureOr<void>> insertPaymentMethod(PaymentMethod paymentMethod);
  Future<FailureOr<bool>> updatePaymentMethod(PaymentMethod paymentMethod);
  Future<FailureOr<void>> deletePaymentMethodWithId(String id);
  Future<FailureOr<int>> countExpensesWithPaymentMethodWithId(String id);
}
