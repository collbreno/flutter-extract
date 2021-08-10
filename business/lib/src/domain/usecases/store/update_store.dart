import 'package:business/business.dart';
import 'package:dartz/dartz.dart';

class UpdateStoreUseCase extends UseCase<bool, Store> {
  final IStoreRepository repository;

  UpdateStoreUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(Store store) {
    return repository.updateStore(store);
  }
}
