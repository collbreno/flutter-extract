import 'package:business/business.dart';

class WatchStoresUseCase extends NoParamStreamUseCase<List<Store>> {
  final IStoreRepository repository;

  WatchStoresUseCase(this.repository);

  @override
  Stream<FailureOr<List<Store>>> call() {
    return repository.watchAll();
  }
}
