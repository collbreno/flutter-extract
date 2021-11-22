import 'package:business/business.dart';
import 'package:business/src/domain/repositories/subcategory_repository.dart';

class UpdateSubcategoryUseCase extends UseCase<void, Subcategory> {
  final ISubcategoryRepository repository;

  UpdateSubcategoryUseCase(this.repository);

  @override
  Future<FailureOr<void>> call(Subcategory subcategory) {
    return repository.update(subcategory);
  }
}
