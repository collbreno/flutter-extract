import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:dartz/dartz.dart';

class UpdateTag extends UseCase<void, Tag> {
  final ITagRepository repository;

  UpdateTag(this.repository);

  @override
  Future<Either<Failure, void>> call(Tag tag) {
    return repository.updateTag(tag);
  }
}
