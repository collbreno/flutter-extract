import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:dartz/dartz.dart';

class ForceDeleteTagWithId extends UseCase<void, String> {
  final ITagRepository repository;

  ForceDeleteTagWithId(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) {
    return repository.deleteTagWithId(id);
  }
}
