import 'package:business/business.dart';
import 'package:dartz/dartz.dart';

class GetTagsUseCase extends NoParamFutureUseCase<List<Tag>> {
  final ITagRepository repository;

  GetTagsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Tag>>> call() {
    return repository.getAll();
  }
}
