import 'package:infrastructure/infrastructure.dart';

class CategoryRepository {
  final AppDatabase database;

  CategoryRepository(this.database);

  Future<CategoryEntity?> getCategoryFromDatabase(int categoryId) {
    return database.categoryDao.getCategoryById(categoryId);
  }

  Future<List<CategoryEntity>> getAllCategoriesFromDatabase() {
    return database.categoryDao.getAllCategories();
  }
}
