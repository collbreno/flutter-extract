import 'package:infrastructure/infrastructure.dart';
import 'package:infrastructure/src/daos/interfaces.dart';
import 'package:moor/moor.dart';

part 'store_dao.g.dart';

@UseDao(tables: [Stores])
class StoreDao extends DatabaseAccessor<AppDatabase>
    with _$StoreDaoMixin
    implements IEntityDao<StoreEntity> {
  final AppDatabase db;

  StoreDao(this.db) : super(db);

  @override
  Future<List<StoreEntity>> getAll() {
    return select(stores).get();
  }

  @override
  Future<StoreEntity?> getById(String id) {
    final query = select(stores)..where((s) => s.id.equals(id));
    return query.getSingleOrNull();
  }

  @override
  Future<int> insert(Insertable<StoreEntity> store) {
    return into(stores).insert(store);
  }

  @override
  Future<bool> updateWithId(Insertable<StoreEntity> store) {
    return update(stores).replace(store);
  }

  @override
  Future<int> deleteWithId(String id) {
    final query = delete(stores)..where((s) => s.id.equals(id));
    return query.go();
  }
}
