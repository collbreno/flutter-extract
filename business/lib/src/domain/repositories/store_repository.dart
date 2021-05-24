import 'package:business/src/core/core.dart';
import 'package:business/src/domain/entities/entities.dart';

abstract class IStoreRepository {
  Future<FailureOr<List<Store>>> getAllStores();
  Future<FailureOr<Store>> getStoreById(String id);
  Future<FailureOr<void>> insertStore(Store store);
  Future<FailureOr<bool>> updateStore(Store store);
  Future<FailureOr<void>> deleteStoreWithId(String id);
}
