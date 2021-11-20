import 'package:business/business.dart';
import 'package:dartz/dartz.dart';

class GetAllStoresUseCase extends NoParamUseCase<List<Store>> {
  final IStoreRepository repository;

  GetAllStoresUseCase(this.repository);

  @override
  Future<Either<Failure, List<Store>>> call() {
    return repository.getAll();
  }
}
