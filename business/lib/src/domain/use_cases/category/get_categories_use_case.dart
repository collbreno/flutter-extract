import 'package:business/business.dart';
import 'package:dartz/dartz.dart';

class GetCategoriesUseCase extends NoParamFutureUseCase<List<Category>> {
  final ICategoryRepository repository;

  GetCategoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Category>>> call() {
    return repository.getAll();
  }
}
