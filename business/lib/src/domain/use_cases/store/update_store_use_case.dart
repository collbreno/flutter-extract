import 'package:business/business.dart';
import 'package:dartz/dartz.dart';

class UpdateStoreUseCase extends UseCase<void, Store> {
  final IStoreRepository repository;

  UpdateStoreUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Store store) {
    return repository.update(store);
  }
}
