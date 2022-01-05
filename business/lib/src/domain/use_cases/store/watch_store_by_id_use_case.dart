import 'package:business/business.dart';

class WatchStoreByIdUseCase extends StreamUseCase<Store, String> {
  final IStoreRepository repository;

  WatchStoreByIdUseCase(this.repository);

  @override
  Stream<FailureOr<Store>> call(String id) {
    return repository.watchById(id);
  }
}
