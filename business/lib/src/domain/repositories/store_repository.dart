import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';

abstract class IStoreRepository {
  Future<FailureOr<List<Store>>> getAllStores();
  Future<FailureOr<Store>> getStoreById(String id);
  Future<FailureOr<void>> insertStore(Store store);
  Future<FailureOr<void>> updateStore(Store store);
  Future<FailureOr<void>> deleteStoreWithId(String id);
  Future<FailureOr<int>> countUsages(String id);
}
