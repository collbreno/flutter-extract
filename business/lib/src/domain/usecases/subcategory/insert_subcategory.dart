import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:business/src/domain/repositories/subcategory_repository.dart';

class InsertSubcategory extends UseCase<void, Subcategory> {
  final ISubcategoryRepository repository;

  InsertSubcategory(this.repository);

  @override
  Future<FailureOr<void>> call(Subcategory subcategory) {
    return repository.insertSubcategory(subcategory);
  }
}
