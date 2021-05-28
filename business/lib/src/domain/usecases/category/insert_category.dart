import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:dartz/dartz.dart';

class InsertCategory extends UseCase<void, Category> {
  final ICategoryRepository repository;

  InsertCategory(this.repository);

  @override
  Future<Either<Failure, void>> call(Category category) {
    // TODO: implement call
    throw UnimplementedError();
  }
}
