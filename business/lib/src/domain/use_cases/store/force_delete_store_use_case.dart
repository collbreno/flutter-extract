import 'package:business/business.dart';
import 'package:dartz/dartz.dart';

class ForceDeleteStoreUseCase extends FutureUseCase<void, String> {
  final IStoreRepository repository;

  ForceDeleteStoreUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) {
    return repository.delete(id);
  }
}
