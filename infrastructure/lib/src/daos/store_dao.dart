import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

part 'store_dao.g.dart';

@UseDao(tables: [Stores])
class StoreDao extends DatabaseAccessor<AppDatabase> with _$StoreDaoMixin {
  final AppDatabase db;

  StoreDao(this.db) : super(db);

  Future<List<StoreEntity>> getAllStores() {
    return select(stores).get();
  }

  Future<StoreEntity?> getStoreById(int id) {
    final query = select(stores)..where((s) => s.id.equals(id));
    return query.getSingleOrNull();
  }

  Future<int> insertStore(Insertable<StoreEntity> store) {
    return into(stores).insert(store);
  }

  Future<bool> updateStore(Insertable<StoreEntity> store) {
    return update(stores).replace(store);
  }

  Future<int> deleteStoreWithId(int id) {
    final query = delete(stores)..where((s) => s.id.equals(id));
    return query.go();
  }

}
