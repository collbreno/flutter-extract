import 'package:business/business.dart';

abstract class ICategoryRepository {
  Future<FailureOr<List<Category>>> getAll();
  Future<FailureOr<Category>> getById(String id);
  Stream<FailureOr<Category>> watchById(String id);
  Future<FailureOr<int>> countUsages(String id);
  Future<FailureOr<void>> insert(Category category);
  Future<FailureOr<void>> update(Category category);
  Future<FailureOr<void>> delete(String categoryId);
}
