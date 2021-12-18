import 'package:business/business.dart';
import 'package:dartz/dartz.dart';

class InsertStoreUseCase extends FutureUseCase<void, Store> {
  final IStoreRepository repository;

  InsertStoreUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Store store) {
    return repository.insert(store);
  }
}
