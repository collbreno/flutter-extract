import 'dart:async';

import 'package:business/business.dart';
import 'package:dartz/dartz.dart';
import 'package:infrastructure/infrastructure.dart';

class CategoryRepository implements ICategoryRepository {
  final AppDatabase db;

  CategoryRepository(this.db);

  @override
  Future<FailureOr<int>> countUsages(String categoryId) async {
    try {
      final query = db.select(db.subcategories)..where((e) => e.parentId.equals(categoryId));
      final usages = (await query.get()).length;
      return Right(usages);
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Future<FailureOr<void>> delete(String categoryId) async {
    try {
      final query = db.delete(db.categories)..where((c) => c.id.equals(categoryId));
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

  @override
  Future<FailureOr<List<Category>>> getAll() async {
    try {
      final categories = await db.select(db.categories).get();
      if (categories.isNotEmpty) {
        return Right(categories.map((c) => c.toModel()).toList());
      }
      return Left(NotFoundFailure());
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Future<FailureOr<Category>> getById(String id) async {
    try {
      final query = db.select(db.categories)..where((c) => c.id.equals(id));
      final category = await query.getSingleOrNull();

      if (category != null) {
        return Right(category.toModel());
      } else {
        return Left(NotFoundFailure());
      }
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Stream<FailureOr<Category>> watchById(String id) {
    final query = db.select(db.categories)..where((c) => c.id.equals(id));
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

  @override
  Stream<FailureOr<List<Category>>> watchAll() {
    final query = db.select(db.categories);
    return query.watch().transform(StreamTransformer.fromHandlers(
          handleData: (data, sink) {
            if (data.isEmpty) {
              sink.add(Left(NotFoundFailure()));
            } else {
              sink.add(Right(data.map((e) => e.toModel()).toList()));
            }
          },
          handleError: (error, stackTrace, sink) {
            sink.add(Left(UnknownDatabaseFailure()));
          },
        ));
  }

  @override
  Future<FailureOr<void>> insert(Category category) async {
    try {
      await db.into(db.categories).insert(category.toEntity());
      return Right(Null);
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Future<FailureOr<void>> update(Category category) async {
    try {
      final result = await db.update(db.categories).replace(category.toEntity());
      if (result) {
        return Right(Null);
      } else {
        return Left(NotFoundFailure());
      }
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }
}
