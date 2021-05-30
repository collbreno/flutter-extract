// Mocks generated by Mockito 5.0.8 from annotations
// in business/test/domain/usecases/tag/_mock.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:business/src/core/errors/failure.dart' as _i5;
import 'package:business/src/domain/entities/tag.dart' as _i6;
import 'package:business/src/domain/repositories/tag_repository.dart' as _i3;
import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: comment_references
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeEither<L, R> extends _i1.Fake implements _i2.Either<L, R> {}

/// A class which mocks [ITagRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockITagRepository extends _i1.Mock implements _i3.ITagRepository {
  MockITagRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.Tag>>> getAllTags() =>
      (super.noSuchMethod(Invocation.method(#getAllTags, []),
              returnValue: Future<_i2.Either<_i5.Failure, List<_i6.Tag>>>.value(
                  _FakeEither<_i5.Failure, List<_i6.Tag>>()))
          as _i4.Future<_i2.Either<_i5.Failure, List<_i6.Tag>>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Tag>> getTagById(String? id) =>
      (super.noSuchMethod(Invocation.method(#getTagById, [id]),
              returnValue: Future<_i2.Either<_i5.Failure, _i6.Tag>>.value(
                  _FakeEither<_i5.Failure, _i6.Tag>()))
          as _i4.Future<_i2.Either<_i5.Failure, _i6.Tag>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, int>> countExpensesWithTagWithId(
          String? id) =>
      (super.noSuchMethod(Invocation.method(#countExpensesWithTagWithId, [id]),
              returnValue: Future<_i2.Either<_i5.Failure, int>>.value(
                  _FakeEither<_i5.Failure, int>()))
          as _i4.Future<_i2.Either<_i5.Failure, int>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, void>> insertTag(_i6.Tag? tag) =>
      (super.noSuchMethod(Invocation.method(#insertTag, [tag]),
              returnValue: Future<_i2.Either<_i5.Failure, void>>.value(
                  _FakeEither<_i5.Failure, void>()))
          as _i4.Future<_i2.Either<_i5.Failure, void>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, bool>> updateTag(_i6.Tag? tag) =>
      (super.noSuchMethod(Invocation.method(#updateTag, [tag]),
              returnValue: Future<_i2.Either<_i5.Failure, bool>>.value(
                  _FakeEither<_i5.Failure, bool>()))
          as _i4.Future<_i2.Either<_i5.Failure, bool>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, void>> deleteTagWithId(String? id) =>
      (super.noSuchMethod(Invocation.method(#deleteTagWithId, [id]),
              returnValue: Future<_i2.Either<_i5.Failure, void>>.value(
                  _FakeEither<_i5.Failure, void>()))
          as _i4.Future<_i2.Either<_i5.Failure, void>>);
}
