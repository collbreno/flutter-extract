import 'package:business/business.dart';

abstract class IStoreRepository {
  Future<FailureOr<List<Store>>> getAll();

  Stream<FailureOr<List<Store>>> watchAll();

  Future<FailureOr<Store>> getById(String id);

  Stream<FailureOr<Store>> watchById(String id);

  Future<FailureOr<void>> insert(Store store);

  Future<FailureOr<void>> update(Store store);

  Future<FailureOr<void>> delete(String id);

  Future<FailureOr<int>> countUsages(String id);
}
