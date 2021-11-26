import 'package:business/business.dart';
import 'package:dartz/dartz.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

class SubcategoryRepository implements ISubcategoryRepository {
  final AppDatabase db;

  SubcategoryRepository(this.db);

  @override
  Future<FailureOr<int>> countUsages(String id) async {
    try {
      final query = db.select(db.expenses)..where((e) => e.subcategoryId.equals(id));
      final usages = (await query.get()).length;
      return Right(usages);
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Future<FailureOr<void>> delete(String id) async {
    try {
      final query = db.delete(db.subcategories)..where((s) => s.id.equals(id));
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
  Future<FailureOr<List<Subcategory>>> getAll() async {
    try {
      final query = _mountSubcategoryQuery();
      final subcategories = await query.get();

      if (subcategories.isEmpty) {
        return Left(NotFoundFailure());
      }

      return Right(
        subcategories.map((row) {
          return row.readTable(db.subcategories).toModel(
                parent: row.readTable(db.categories).toModel(),
              );
        }).toList(),
      );
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Future<FailureOr<Subcategory>> getById(String id) async {
    try {
      final query = _mountSubcategoryQuery()..where(db.subcategories.id.equals(id));
      final result = await query.getSingleOrNull();

      if (result == null) {
        return Left(NotFoundFailure());
      }

      return Right(
        result
            .readTable(db.subcategories)
            .toModel(parent: result.readTable(db.categories).toModel()),
      );
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Future<FailureOr<List<Subcategory>>> getByParentId(String id) async {
    try {
      final query = _mountSubcategoryQuery()..where(db.subcategories.parentId.equals(id));
      final subcategories = await query.get();

      if (subcategories.isEmpty) {
        return Left(NotFoundFailure());
      }

      return Right(
        subcategories.map((row) {
          return row.readTable(db.subcategories).toModel(
                parent: row.readTable(db.categories).toModel(),
              );
        }).toList(),
      );
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Future<FailureOr<void>> insert(Subcategory subcategory) async {
    try {
      await db.into(db.subcategories).insert(subcategory.toEntity());
      return Right(Null);
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Future<FailureOr<void>> update(Subcategory subcategory) async {
    try {
      final result = await db.update(db.subcategories).replace(subcategory.toEntity());

      if (!result) {
        return Left(NotFoundFailure());
      }

      return Right(Null);
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  JoinedSelectStatement _mountSubcategoryQuery() {
    return db.select(db.subcategories).join([
      innerJoin(db.categories, db.categories.id.equalsExp(db.subcategories.parentId)),
    ]);
  }
}
