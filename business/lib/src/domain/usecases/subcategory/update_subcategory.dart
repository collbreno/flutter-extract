import 'package:business/src/core/core.dart';
import 'package:business/src/domain/entities/entities.dart';
import 'package:business/src/domain/repositories/subcategory_repository.dart';

class UpdateSubcategory extends UseCase<bool, Subcategory> {
  final ISubcategoryRepository repository;

  UpdateSubcategory(this.repository);

  @override
  Future<FailureOr<bool>> call(Subcategory subcategory) {
    return repository.updateSubcategory(subcategory);
  }
}
