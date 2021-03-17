import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

part 'payment_method_dao.g.dart';

@UseDao(tables: [PaymentMethods])
class PaymentMethodDao extends DatabaseAccessor<AppDatabase> with _$PaymentMethodDaoMixin {
  final AppDatabase db;

  PaymentMethodDao(this.db) : super(db);

  Future<List<PaymentMethod>> getAllPaymentMethods() {
    throw UnimplementedError();
  }

  Future<PaymentMethod> getPaymentMethodById(int id) {
    throw UnimplementedError();
  }

  Future<int> insertPaymentMethod(Insertable<PaymentMethod> paymentMethod) {
    throw UnimplementedError();
  }

  Future<bool> updatePaymentMethod(Insertable<PaymentMethod> paymentMethod) {
    throw UnimplementedError();
  }

  Future<int> deletePaymentMethodWithId(int id) {
    throw UnimplementedError();
  }

}
