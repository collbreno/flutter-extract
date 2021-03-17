import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

part 'store_dao.g.dart';

@UseDao(tables: [Stores])
class StoreDao extends DatabaseAccessor<AppDatabase> with _$StoreDaoMixin {
  final AppDatabase db;

  StoreDao(this.db) : super(db);

  Future<List<Store>> getAllStores() {
    throw UnimplementedError();
  }

  Future<Store> getStoreById(int id) {
    throw UnimplementedError();
  }

  Future<int> insertStore(Insertable<Store> store) {
    throw UnimplementedError();
  }

  Future<bool> updateStore(Insertable<Store> store) {
    throw UnimplementedError();
  }

  Future<int> deleteStoreWithId(int id) {
    throw UnimplementedError();
  }

}
