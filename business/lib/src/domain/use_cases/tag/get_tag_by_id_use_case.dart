import 'package:business/business.dart';
import 'package:dartz/dartz.dart';

class GetTagByIdUseCase extends FutureUseCase<Tag, String> {
  final ITagRepository repository;

  GetTagByIdUseCase(this.repository);

  @override
  Future<Either<Failure, Tag>> call(String id) {
    return repository.getById(id);
  }
}
