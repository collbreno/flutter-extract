import 'package:business/business.dart';
import 'package:dartz/dartz.dart';

class InsertCategoryUseCase extends FutureUseCase<void, Category> {
  final ICategoryRepository repository;

  InsertCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Category category) {
    return repository.insert(category);
  }
}
