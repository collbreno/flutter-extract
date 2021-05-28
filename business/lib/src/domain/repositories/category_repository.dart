import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';

abstract class ICategoryRepository {
  Future<FailureOr<List<Category>>> getAllCategories();
  Future<FailureOr<Category>> getCategoryById(String id);
  Future<FailureOr<bool>> existsCategoryWithId(String id);
  Future<FailureOr<int>> countSubcategoriesWithParentId(String id);
  Future<FailureOr<void>> insertCategory(Category category);
  Future<FailureOr<bool>> updateCategory(Category category);
  Future<FailureOr<int>> deleteCategoryWithId(String id);
}
