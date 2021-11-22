import 'package:business/business.dart';
import 'package:dartz/dartz.dart';

class InsertTagUseCase extends UseCase<void, Tag> {
  final ITagRepository repository;

  InsertTagUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Tag tag) {
    return repository.insert(tag);
  }
}
