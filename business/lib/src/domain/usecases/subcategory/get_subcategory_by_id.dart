import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:business/src/domain/repositories/subcategory_repository.dart';

class GetSubcategoryById extends UseCase<Subcategory, String> {
  final ISubcategoryRepository repository;

  GetSubcategoryById(this.repository);

  @override
  Future<FailureOr<Subcategory>> call(String id) {
    return repository.getSubcategoryById(id);
  }
}
