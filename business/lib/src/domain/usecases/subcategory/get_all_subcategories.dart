import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:business/src/domain/repositories/subcategory_repository.dart';

class GetAllSubcategories extends NoParamUseCase<List<Subcategory>> {
  final ISubcategoryRepository repository;

  GetAllSubcategories(this.repository);

  @override
  Future<FailureOr<List<Subcategory>>> call() {
    return repository.getAllSubcategories();
  }
}
