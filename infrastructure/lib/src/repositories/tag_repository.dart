import 'package:business/business.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:infrastructure/infrastructure.dart';

class TagRepository implements ITagRepository {
  final AppDatabase db;

  TagRepository(this.db);

  @override
  Future<FailureOr<int>> countUsages(String tagId) async {
    try {
      final query = db.select(db.expenseTags)..where((e) => e.tagId.equals(tagId));
      final usages = (await query.get()).length;
      return Right(usages);
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Future<FailureOr<void>> deleteTagWithId(String tagId) async {
    try {
      final query = db.delete(db.tags)..where((t) => t.id.equals(tagId));
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
  Future<FailureOr<List<Tag>>> getAllTags() async {
    try {
      final tags = await db.select(db.tags).get();
      if (tags.isNotEmpty) {
        return Right(
          tags.map(_mapToModel).toList(),
        );
      } else {
        return Left(NotFoundFailure());
      }
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Future<FailureOr<Tag>> getTagById(String tagId) async {
    try {
      final query = db.select(db.tags)..where((t) => t.id.equals(tagId));
      final tag = await query.getSingleOrNull();

      if (tag != null) {
        return Right(_mapToModel(tag));
      } else {
        return Left(NotFoundFailure());
      }
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Future<FailureOr<void>> insertTag(Tag tag) async {
    try {
      await db.into(db.tags).insert(_mapToEntity(tag));
      return Right(Null);
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Future<FailureOr<void>> updateTag(Tag tag) async {
    try {
      final result = await db.update(db.tags).replace(_mapToEntity(tag));
      if (result) {
        return Right(Null);
      } else {
        return Left(NotFoundFailure());
      }
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  Tag _mapToModel(TagEntity entity) {
    return Tag(
      id: entity.id,
      name: entity.name,
      color: Color(entity.color),
      icon: entity.iconName != null && entity.iconFamily != null
          ? IconMapper.getIcon(name: entity.iconName!, family: entity.iconFamily!)
          : null,
    );
  }

  TagEntity _mapToEntity(Tag model) {
    return TagEntity(
      id: model.id,
      name: model.name,
      color: model.color.value,
      iconName: model.icon != null ? IconMapper.getIconName(model.icon!) : null,
      iconFamily: model.icon != null ? IconMapper.getIconFamily(model.icon!) : null,
    );
  }
}
