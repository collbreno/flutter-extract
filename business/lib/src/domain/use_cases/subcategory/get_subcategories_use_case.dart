import 'package:business/business.dart';
import 'package:business/src/domain/repositories/subcategory_repository.dart';

class GetSubcategoriesUseCase extends NoParamFutureUseCase<List<Subcategory>> {
  final ISubcategoryRepository repository;

  GetSubcategoriesUseCase(this.repository);

  @override
  Future<FailureOr<List<Subcategory>>> call() {
    return repository.getAll();
  }
}
