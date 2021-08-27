import 'package:business/business.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
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
  Future<FailureOr<void>> deleteCategory(String categoryId) async {
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
  Future<FailureOr<List<Category>>> getAllCategories() async {
    try {
      final categories = await db.select(db.categories).get();
      if (categories.isNotEmpty) {
        return Right(categories.map((_mapToModel)).toList());
      }
      return Left(NotFoundFailure());
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Future<FailureOr<Category>> getCategoryById(String id) async {
    try {
      final query = db.select(db.categories)..where((c) => c.id.equals(id));
      final category = await query.getSingleOrNull();

      if (category != null) {
        return Right(_mapToModel(category));
      } else {
        return Left(NotFoundFailure());
      }
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Future<FailureOr<void>> insertCategory(Category category) async {
    try {
      await db.into(db.categories).insert(_mapToEntity(category));
      return Right(Null);
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Future<FailureOr<void>> updateCategory(Category category) async {
    try {
      final result = await db.update(db.categories).replace(_mapToEntity(category));
      if (result) {
        return Right(Null);
      } else {
        return Left(NotFoundFailure());
      }
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  Category _mapToModel(CategoryEntity entity) {
    return Category(
      id: entity.id,
      name: entity.name,
      color: Color(entity.color),
      icon: IconMapper.getIcon(name: entity.iconName, family: entity.iconFamily),
    );
  }

  CategoryEntity _mapToEntity(Category model) {
    return CategoryEntity(
      id: model.id,
      name: model.name,
      iconName: IconMapper.getIconName(model.icon),
      iconFamily: IconMapper.getIconFamily(model.icon),
      color: model.color.value,
    );
  }
}
