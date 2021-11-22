import 'package:business/business.dart';
import 'package:dartz/dartz.dart';

class UpdateTagUseCase extends UseCase<void, Tag> {
  final ITagRepository repository;

  UpdateTagUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Tag tag) {
    return repository.update(tag);
  }
}
