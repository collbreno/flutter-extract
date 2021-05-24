import 'package:business/src/core/core.dart';
import 'package:business/src/domain/entities/entities.dart';

abstract class ISubcategoryRepository {
  Future<FailureOr<List<Subcategory>>> getAllSubcategories();
  Future<FailureOr<int>> countExpensesWithSubcategoryWithId(String id);
  Future<FailureOr<Subcategory>> getSubcategoryById(String id);
  Future<FailureOr<void>> insertSubcategory(Subcategory subcategory);
  Future<FailureOr<bool>> updateSubcategory(Subcategory subcategory);
  Future<FailureOr<int>> deleteSubcategoryWithId(String id);
}
