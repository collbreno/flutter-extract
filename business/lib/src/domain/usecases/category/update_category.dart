import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:dartz/dartz.dart';

class UpdateCategory extends UseCase<bool, Category> {
  final ICategoryRepository repository;

  UpdateCategory(this.repository);

  @override
  Future<Either<Failure, bool>> call(Category category) {
    // TODO: implement call
    throw UnimplementedError();
  }
}
