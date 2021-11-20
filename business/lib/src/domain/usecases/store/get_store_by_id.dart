import 'package:business/business.dart';
import 'package:dartz/dartz.dart';

class GetStoreByIdUseCase extends UseCase<Store, String> {
  final IStoreRepository repository;

  GetStoreByIdUseCase(this.repository);

  @override
  Future<Either<Failure, Store>> call(String id) {
    return repository.getById(id);
  }
}
