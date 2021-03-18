import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

part 'payment_method_dao.g.dart';

@UseDao(tables: [PaymentMethods])
class PaymentMethodDao extends DatabaseAccessor<AppDatabase> with _$PaymentMethodDaoMixin {
  final AppDatabase db;

  PaymentMethodDao(this.db) : super(db);

  Future<List<PaymentMethod>> getAllPaymentMethods() {
    return select(paymentMethods).get();
  }

  Future<PaymentMethod> getPaymentMethodById(int id) {
    final query = select(paymentMethods)..where((pm) => pm.id.equals(id));
    return query.getSingle();
  }

  Future<int> insertPaymentMethod(Insertable<PaymentMethod> paymentMethod) {
    return into(paymentMethods).insert(paymentMethod);
  }

  Future<bool> updatePaymentMethod(Insertable<PaymentMethod> paymentMethod) {
    return update(paymentMethods).replace(paymentMethod);
  }

  Future<int> deletePaymentMethodWithId(int id) {
    final query = delete(paymentMethods)..where((pm) => pm.id.equals(id));
    return query.go();
  }

}
