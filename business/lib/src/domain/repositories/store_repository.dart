import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';

abstract class IStoreRepository {
  Future<FailureOr<List<Store>>> getAll();
  Future<FailureOr<Store>> getById(String id);
  Future<FailureOr<void>> insert(Store store);
  Future<FailureOr<void>> update(Store store);
  Future<FailureOr<void>> delete(String id);
  Future<FailureOr<int>> countUsages(String id);
}
