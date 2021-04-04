import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

part 'category_dao.g.dart';

@UseDao(tables: [Categories])
class CategoryDao extends DatabaseAccessor<AppDatabase> with _$CategoryDaoMixin {
  final AppDatabase db;

  CategoryDao(this.db) : super(db);

  Future<List<CategoryEntity>> getAllCategories() => select(categories).get();

  Future<int> getCategoriesAmount() {
    final count = categories.id.count();
    final query = selectOnly(categories)..addColumns([count]);
    return query.map((row) => row.read(count)).getSingle();
  }

  Future<int> insertCategory(Insertable<CategoryEntity> category) => into(categories).insert(category);

  Future<bool> updateCategory(Insertable<CategoryEntity> category) =>
      update(categories).replace(category);

  Future<int> deleteCategoryWithId(int id) {
    final query = delete(categories)..where((c) => c.id.equals(id));
    return query.go();
  }

  Future<CategoryEntity> getCategoryById(int id) {
    final query = select(categories)..where((c) => c.id.equals(id));
    return query.getSingle();
  }
}
