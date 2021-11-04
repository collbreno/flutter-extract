import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:dartz/dartz.dart';

class GetAllCategories extends NoParamUseCase<List<Category>> {
  final ICategoryRepository repository;

  GetAllCategories(this.repository);

  @override
  Future<Either<Failure, List<Category>>> call() {
    return repository.getAllCategories();
  }
}
