import 'package:business/business.dart';
import 'package:dartz/dartz.dart';

class UpdateCategoryUseCase extends UseCase<void, Category> {
  final ICategoryRepository repository;

  UpdateCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Category category) {
    return repository.update(category);
  }
}
