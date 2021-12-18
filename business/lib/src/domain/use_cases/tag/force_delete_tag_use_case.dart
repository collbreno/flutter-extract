import 'package:business/business.dart';
import 'package:dartz/dartz.dart';

class ForceDeleteTagUseCase extends FutureUseCase<void, String> {
  final ITagRepository repository;

  ForceDeleteTagUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) {
    return repository.delete(id);
  }
}
