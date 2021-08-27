import 'package:business/business.dart';
import 'package:business/src/core/typedefs.dart';
import 'package:dartz/dartz.dart';
import 'package:infrastructure/infrastructure.dart';

class StoreRepository implements IStoreRepository {
  final AppDatabase db;

  StoreRepository(this.db);

  /// Deletes the store with the given id.
  /// Returns void if succeeded.
  /// Returns [NothingToDeleteFailure] when there is no store with the given id.
  /// Returns [UnknownDatabaseFailure] when datasource fails.
  @override
  Future<FailureOr<void>> deleteStoreWithId(String id) async {
    try {
      final query = db.delete(db.stores)..where((s) => s.id.equals(id));
      final countDeleted = await query.go();

      if (countDeleted != 0) {
        return Right(Null);
      } else {
        return Left(NothingToDeleteFailure());
      }
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  /// Get all the stores.
  /// Returns a not empty list when succeeded.
  /// Returns [NotFoundFailure] when there are no stores.
  /// Returns [UnknownDatabaseFailure] when datasource fails.
  @override
  Future<FailureOr<List<Store>>> getAllStores() async {
    try {
      final stores = await db.select(db.stores).get();
      if (stores.isNotEmpty) {
        return Right(
          stores.map(_mapToModel).toList(),
        );
      } else {
        return Left(NotFoundFailure());
      }
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  /// Get the store with the given id.
  /// Returns the store.
  /// Returns a store when succeeded.
  /// Returns [NotFoundFailure] when there are no stores with the given id.
  /// Returns [UnknownDatabaseFailure] when datasource fails.

  @override
  Future<FailureOr<Store>> getStoreById(String id) async {
    try {
      final query = db.select(db.stores)..where((s) => s.id.equals(id));
      final store = await query.getSingleOrNull();

      if (store != null) {
        return Right(_mapToModel(store));
      } else {
        return Left(NotFoundFailure());
      }
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  /// Insert the given store.
  /// Returns void when succeeded.
  /// Returns [UnknownDatabaseFailure] when datasource fails.
  @override
  Future<FailureOr<void>> insertStore(Store store) async {
    try {
      await db.into(db.stores).insert(_mapToEntity(store));
      return Right(Null);
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  /// Update the given store.
  /// Returns true when updated and false when nothing changed.
  /// Returns [UnknownDatabaseFailure] when datasource fails.
  @override
  Future<FailureOr<void>> updateStore(Store store) async {
    try {
      final result = await db.update(db.stores).replace(_mapToEntity(store));
      if (result) {
        return Right(Null);
      } else {
        return Left(NotFoundFailure());
      }
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Future<FailureOr<int>> countUsages(String storeId) async {
    try {
      final query = db.select(db.expenses)..where((e) => e.storeId.equals(storeId));
      final usages = (await query.get()).length;
      return Right(usages);
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  Store _mapToModel(StoreEntity entity) {
    return Store(id: entity.id, name: entity.name);
  }

  StoreEntity _mapToEntity(Store model) {
    return StoreEntity(id: model.id, name: model.name);
  }
}
