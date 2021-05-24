import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:business/src/domain/repositories/subcategory_repository.dart';

class UpdateSubcategory extends UseCase<bool, Subcategory> {
  final ISubcategoryRepository repository;

  UpdateSubcategory(this.repository);

  @override
  Future<FailureOr<bool>> call(Subcategory subcategory) {
    return repository.updateSubcategory(subcategory);
  }
}
