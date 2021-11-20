import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';

abstract class ISubcategoryRepository {
  Future<FailureOr<List<Subcategory>>> getAll();
  Future<FailureOr<List<Subcategory>>> getByParentId(String id);
  Future<FailureOr<int>> countUsages(String id);
  Future<FailureOr<Subcategory>> getById(String id);
  Future<FailureOr<void>> insert(Subcategory subcategory);
  Future<FailureOr<void>> update(Subcategory subcategory);
  Future<FailureOr<void>> delete(String id);
}
