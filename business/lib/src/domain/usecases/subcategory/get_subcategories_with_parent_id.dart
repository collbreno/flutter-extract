import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:business/src/domain/repositories/subcategory_repository.dart';

class GetSubcategoriesWithParentId extends UseCase<List<Subcategory>, String> {
  final ISubcategoryRepository repository;

  GetSubcategoriesWithParentId(this.repository);

  @override
  Future<FailureOr<List<Subcategory>>> call(String parentId) {
    return repository.getByParentId(parentId);
  }
}
