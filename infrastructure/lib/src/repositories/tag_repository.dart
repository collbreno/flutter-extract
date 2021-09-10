import 'package:business/business.dart';
import 'package:dartz/dartz.dart';
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
          tags.map((t) => t.toModel()).toList(),
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
        return Right(tag.toModel());
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
      await db.into(db.tags).insert(tag.toEntity());
      return Right(Null);
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Future<FailureOr<void>> updateTag(Tag tag) async {
    try {
      final result = await db.update(db.tags).replace(tag.toEntity());
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
