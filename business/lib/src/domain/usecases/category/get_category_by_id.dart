import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:dartz/dartz.dart';

class GetCategoryById extends UseCase<Category, String> {
  final ICategoryRepository repository;

  GetCategoryById(this.repository);

  @override
  Future<Either<Failure, Category>> call(String id) {
    return repository.getCategoryById(id);
  }
}
