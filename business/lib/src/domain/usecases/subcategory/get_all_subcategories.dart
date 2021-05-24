import 'package:business/src/core/core.dart';
import 'package:business/src/domain/entities/entities.dart';
import 'package:business/src/domain/repositories/subcategory_repository.dart';

class GetAllSubcategories extends UseCase<List<Subcategory>, NoParams> {
  final ISubcategoryRepository repository;

  GetAllSubcategories(this.repository);

  @override
  Future<FailureOr<List<Subcategory>>> call(NoParams param) {
    return repository.getAllSubcategories();
  }
}
