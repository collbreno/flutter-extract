import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

part 'store_dao.g.dart';

@UseDao(tables: [Stores])
class StoreDao extends DatabaseAccessor<AppDatabase> with _$StoreDaoMixin {
  final AppDatabase db;

  StoreDao(this.db) : super(db);

  Future<List<Store>> getAllStores() {
    return select(stores).get();
  }

  Future<Store> getStoreById(int id) {
    final query = select(stores)..where((s) => s.id.equals(id));
    return query.getSingle();
  }

  Future<int> insertStore(Insertable<Store> store) {
    return into(stores).insert(store);
  }

  Future<bool> updateStore(Insertable<Store> store) {
    return update(stores).replace(store);
  }

  Future<int> deleteStoreWithId(int id) {
    final query = delete(stores)..where((s) => s.id.equals(id));
    return query.go();
  }

}
