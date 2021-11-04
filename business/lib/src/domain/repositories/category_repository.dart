import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';

abstract class ICategoryRepository {
  Future<FailureOr<List<Category>>> getAllCategories();
  Future<FailureOr<Category>> getCategoryById(String id);
  Future<FailureOr<int>> countUsages(String id);
  Future<FailureOr<void>> insertCategory(Category category);
  Future<FailureOr<void>> updateCategory(Category category);
  Future<FailureOr<void>> deleteCategory(String categoryId);
}
