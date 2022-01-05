import 'dart:async';

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
  Future<FailureOr<void>> delete(String tagId) async {
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
  Future<FailureOr<List<Tag>>> getAll() async {
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
  Stream<FailureOr<List<Tag>>> watchAll() {
    final query = db.select(db.tags);
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

  @override
  Future<FailureOr<Tag>> getById(String tagId) async {
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
  Stream<FailureOr<Tag>> watchById(String tagId) {
    final query = db.select(db.tags)..where((t) => t.id.equals(tagId));
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
  Future<FailureOr<void>> insert(Tag tag) async {
    try {
      await db.into(db.tags).insert(tag.toEntity());
      return Right(Null);
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Future<FailureOr<void>> update(Tag tag) async {
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
