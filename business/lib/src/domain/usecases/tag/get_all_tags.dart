import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:dartz/dartz.dart';

class GetAllTags extends UseCase<List<Tag>, NoParams> {
  final ITagRepository repository;

  GetAllTags(this.repository);

  @override
  Future<Either<Failure, List<Tag>>> call(NoParams param) {
    return repository.getAllTags();
  }
}
