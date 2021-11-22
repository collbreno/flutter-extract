import 'package:business/business.dart';
import 'package:dartz/dartz.dart';

class GetCategoryByIdUseCase extends UseCase<Category, String> {
  final ICategoryRepository repository;

  GetCategoryByIdUseCase(this.repository);

  @override
  Future<Either<Failure, Category>> call(String id) {
    return repository.getById(id);
  }
}
