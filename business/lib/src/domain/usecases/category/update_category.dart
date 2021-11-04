import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:dartz/dartz.dart';

class UpdateCategory extends UseCase<void, Category> {
  final ICategoryRepository repository;

  UpdateCategory(this.repository);

  @override
  Future<Either<Failure, void>> call(Category category) {
    return repository.updateCategory(category);
  }
}
