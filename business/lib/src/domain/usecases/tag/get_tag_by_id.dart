import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:dartz/dartz.dart';

class GetTagById extends UseCase<Tag, String> {
  final ITagRepository repository;

  GetTagById(this.repository);

  @override
  Future<Either<Failure, Tag>> call(String id) {
    return repository.getTagById(id);
  }
}
