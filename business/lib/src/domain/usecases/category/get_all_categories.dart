import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:dartz/dartz.dart';

class GetAllCategories extends UseCase<List<Category>, NoParams> {
  final ICategoryRepository repository;

  GetAllCategories(this.repository);

  @override
  Future<Either<Failure, List<Category>>> call(NoParams param) {
    // TODO: implement call
    throw UnimplementedError();
  }
}
