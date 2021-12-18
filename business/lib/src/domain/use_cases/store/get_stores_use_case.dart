import 'package:business/business.dart';
import 'package:dartz/dartz.dart';

class GetStoresUseCase extends NoParamFutureUseCase<List<Store>> {
  final IStoreRepository repository;

  GetStoresUseCase(this.repository);

  @override
  Future<Either<Failure, List<Store>>> call() {
    return repository.getAll();
  }
}
