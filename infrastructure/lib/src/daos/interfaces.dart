import 'package:moor/moor.dart';

abstract class IEntityDao<T extends DataClass> {
  Future<List<T>> getAll();
  Future<T?> getById(String id);
  Future<int> insert(Insertable<T> entity);
  Future<bool> updateWithId(Insertable<T> entity);
  Future<int> deleteWithId(String id);
}
