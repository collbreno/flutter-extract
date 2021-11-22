import 'package:business/business.dart';
import 'package:business/src/domain/repositories/subcategory_repository.dart';

class InsertSubcategoryUseCase extends UseCase<void, Subcategory> {
  final ISubcategoryRepository repository;

  InsertSubcategoryUseCase(this.repository);

  @override
  Future<FailureOr<void>> call(Subcategory subcategory) async {
    return repository.insert(subcategory);
  }
}
