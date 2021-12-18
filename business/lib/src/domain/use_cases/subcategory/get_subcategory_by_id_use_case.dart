import 'package:business/business.dart';
import 'package:business/src/domain/repositories/subcategory_repository.dart';

class GetSubcategoryByIdUseCase extends FutureUseCase<Subcategory, String> {
  final ISubcategoryRepository repository;

  GetSubcategoryByIdUseCase(this.repository);

  @override
  Future<FailureOr<Subcategory>> call(String id) {
    return repository.getById(id);
  }
}
