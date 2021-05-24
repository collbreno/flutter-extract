import 'package:business/src/core/core.dart';
import 'package:business/src/domain/entities/entities.dart';
import 'package:business/src/domain/repositories/subcategory_repository.dart';

class GetSubcategoryById extends UseCase<Subcategory, String> {
  final ISubcategoryRepository repository;

  GetSubcategoryById(this.repository);

  @override
  Future<FailureOr<Subcategory>> call(String id) {
    return repository.getSubcategoryById(id);
  }
}
