import 'dart:async';

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
  Future<FailureOr<void>> delete(String id) async {
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
  Future<FailureOr<List<Store>>> getAll() async {
    try {
      final stores = await db.select(db.stores).get();
      if (stores.isNotEmpty) {
        return Right(
          stores.map((s) => s.toModel()).toList(),
        );
      } else {
        return Left(NotFoundFailure());
      }
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Stream<FailureOr<List<Store>>> watchAll() {
    final query = db.select(db.stores);
    return query.watch().transform(StreamTransformer.fromHandlers(handleData: (data, sink) {
          if (data.isEmpty) {
            return sink.add(Left(NotFoundFailure()));
          } else {
            sink.add(Right(data.map((e) => e.toModel()).toList()));
          }
        }, handleError: (error, stackTrace, sink) {
          sink.add(Left(UnknownDatabaseFailure()));
        }));
  }

  /// Get the store with the given id.
  /// Returns the store.
  /// Returns a store when succeeded.
  /// Returns [NotFoundFailure] when there are no stores with the given id.
  /// Returns [UnknownDatabaseFailure] when datasource fails.

  @override
  Future<FailureOr<Store>> getById(String id) async {
    try {
      final query = db.select(db.stores)..where((s) => s.id.equals(id));
      final store = await query.getSingleOrNull();

      if (store != null) {
        return Right(store.toModel());
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
  Future<FailureOr<void>> insert(Store store) async {
    try {
      await db.into(db.stores).insert(store.toEntity());
      return Right(Null);
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  /// Update the given store.
  /// Returns true when updated and false when nothing changed.
  /// Returns [UnknownDatabaseFailure] when datasource fails.
  @override
  Future<FailureOr<void>> update(Store store) async {
    try {
      final result = await db.update(db.stores).replace(store.toEntity());
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

  @override
  Stream<FailureOr<Store>> watchById(String id) {
    final query = db.select(db.stores)..where((t) => t.id.equals(id));
    return query.watchSingleOrNull().transform(StreamTransformer.fromHandlers(
          handleData: (data, sink) {
            if (data == null) {
              sink.add(Left(NotFoundFailure()));
            } else {
              sink.add(Right(data.toModel()));
            }
          },
          handleError: (error, stackTrace, sink) {
            sink.add(Left(UnknownDatabaseFailure()));
          },
        ));
  }
}
