import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

part 'payment_method_dao.g.dart';

@UseDao(tables: [PaymentMethods])
class PaymentMethodDao extends DatabaseAccessor<AppDatabase> with _$PaymentMethodDaoMixin {
  final AppDatabase db;

  PaymentMethodDao(this.db) : super(db);

  Future<List<PaymentMethodEntity>> getAllPaymentMethods() {
    return select(paymentMethods).get();
  }

  Future<PaymentMethodEntity?> getPaymentMethodById(String id) {
    final query = select(paymentMethods)..where((pm) => pm.id.equals(id));
    return query.getSingleOrNull();
  }

  Future<int> insertPaymentMethod(Insertable<PaymentMethodEntity> paymentMethod) {
    return into(paymentMethods).insert(paymentMethod);
  }

  Future<bool> updatePaymentMethod(Insertable<PaymentMethodEntity> paymentMethod) {
    return update(paymentMethods).replace(paymentMethod);
  }

  Future<int> deletePaymentMethodWithId(String id) {
    final query = delete(paymentMethods)..where((pm) => pm.id.equals(id));
    return query.go();
  }
}
