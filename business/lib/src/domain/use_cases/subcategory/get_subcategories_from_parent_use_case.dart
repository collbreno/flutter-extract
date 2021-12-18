import 'package:business/business.dart';
import 'package:business/src/domain/repositories/subcategory_repository.dart';

class GetSubcategoriesFromParentUseCase extends FutureUseCase<List<Subcategory>, String> {
  final ISubcategoryRepository repository;

  GetSubcategoriesFromParentUseCase(this.repository);

  @override
  Future<FailureOr<List<Subcategory>>> call(String parentId) {
    return repository.getByParentId(parentId);
  }
}
