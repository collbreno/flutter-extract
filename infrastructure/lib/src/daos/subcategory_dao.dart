import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

part 'subcategory_dao.g.dart';

@UseDao(tables: [Subcategories])
class SubcategoryDao extends DatabaseAccessor<AppDatabase> with _$SubcategoryDaoMixin {
  final AppDatabase db;

  SubcategoryDao(this.db) : super(db);

  Future<List<SubcategoryEntity>> getAllSubcategories() {
    return select(subcategories).get();
  }

  Future<List<SubcategoryEntity>> getSubcategoriesByParentId(int parentId) {
    final query = select(subcategories)..where((s) => s.parentId.equals(parentId));
    return query.get();
  }

  Future<int> insertSubcategory(Insertable<SubcategoryEntity> subcategory) {
    return into(subcategories).insert(subcategory);
  }

  Future<bool> updateSubcategory(Insertable<SubcategoryEntity> subcategory) {
    return update(subcategories).replace(subcategory);
  }

  Future<int> deleteSubcategoryWithId(int id) {
    final query = delete(subcategories)..where((s) => s.id.equals(id));
    return query.go();
  }

  Future<SubcategoryEntity> getSubcategoryById(int id) {
    final query = select(subcategories)..where((s) => s.id.equals(id));
    return query.getSingle();
  }
}
