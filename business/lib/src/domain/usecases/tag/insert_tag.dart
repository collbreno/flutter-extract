import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:dartz/dartz.dart';

class InsertTag extends UseCase<void, Tag> {
  final ITagRepository repository;

  InsertTag(this.repository);

  @override
  Future<Either<Failure, void>> call(Tag tag) {
    return repository.insertTag(tag);
  }
}
