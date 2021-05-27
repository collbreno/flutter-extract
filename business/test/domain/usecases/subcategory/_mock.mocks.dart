// Mocks generated by Mockito 5.0.8 from annotations
// in business/test/domain/usecases/subcategory/_mock.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:business/src/core/errors/failure.dart' as _i5;
import 'package:business/src/domain/entities/category.dart' as _i8;
import 'package:business/src/domain/entities/subcategory.dart' as _i6;
import 'package:business/src/domain/repositories/category_repository.dart'
    as _i7;
import 'package:business/src/domain/repositories/subcategory_repository.dart'
    as _i3;
import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: comment_references
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeEither<L, R> extends _i1.Fake implements _i2.Either<L, R> {}

/// A class which mocks [ISubcategoryRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockISubcategoryRepository extends _i1.Mock
    implements _i3.ISubcategoryRepository {
  MockISubcategoryRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.Subcategory>>>
      getAllSubcategories() => (super.noSuchMethod(
              Invocation.method(#getAllSubcategories, []),
              returnValue:
                  Future<_i2.Either<_i5.Failure, List<_i6.Subcategory>>>.value(
                      _FakeEither<_i5.Failure, List<_i6.Subcategory>>()))
          as _i4.Future<_i2.Either<_i5.Failure, List<_i6.Subcategory>>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, int>> countExpensesWithSubcategoryWithId(
          String? id) =>
      (super.noSuchMethod(
              Invocation.method(#countExpensesWithSubcategoryWithId, [id]),
              returnValue: Future<_i2.Either<_i5.Failure, int>>.value(
                  _FakeEither<_i5.Failure, int>()))
          as _i4.Future<_i2.Either<_i5.Failure, int>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Subcategory>> getSubcategoryById(
          String? id) =>
      (super.noSuchMethod(Invocation.method(#getSubcategoryById, [id]),
          returnValue: Future<_i2.Either<_i5.Failure, _i6.Subcategory>>.value(
              _FakeEither<_i5.Failure, _i6.Subcategory>())) as _i4
          .Future<_i2.Either<_i5.Failure, _i6.Subcategory>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, void>> insertSubcategory(
          _i6.Subcategory? subcategory) =>
      (super.noSuchMethod(Invocation.method(#insertSubcategory, [subcategory]),
              returnValue: Future<_i2.Either<_i5.Failure, void>>.value(
                  _FakeEither<_i5.Failure, void>()))
          as _i4.Future<_i2.Either<_i5.Failure, void>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, bool>> updateSubcategory(
          _i6.Subcategory? subcategory) =>
      (super.noSuchMethod(Invocation.method(#updateSubcategory, [subcategory]),
              returnValue: Future<_i2.Either<_i5.Failure, bool>>.value(
                  _FakeEither<_i5.Failure, bool>()))
          as _i4.Future<_i2.Either<_i5.Failure, bool>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, int>> deleteSubcategoryWithId(
          String? id) =>
      (super.noSuchMethod(Invocation.method(#deleteSubcategoryWithId, [id]),
              returnValue: Future<_i2.Either<_i5.Failure, int>>.value(
                  _FakeEither<_i5.Failure, int>()))
          as _i4.Future<_i2.Either<_i5.Failure, int>>);
}

/// A class which mocks [ICategoryRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockICategoryRepository extends _i1.Mock
    implements _i7.ICategoryRepository {
  MockICategoryRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i8.Category>>> getAllCategories() =>
      (super.noSuchMethod(Invocation.method(#getAllCategories, []),
              returnValue:
                  Future<_i2.Either<_i5.Failure, List<_i8.Category>>>.value(
                      _FakeEither<_i5.Failure, List<_i8.Category>>()))
          as _i4.Future<_i2.Either<_i5.Failure, List<_i8.Category>>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i8.Category>> getCategoryById(
          String? id) =>
      (super.noSuchMethod(Invocation.method(#getCategoryById, [id]),
              returnValue: Future<_i2.Either<_i5.Failure, _i8.Category>>.value(
                  _FakeEither<_i5.Failure, _i8.Category>()))
          as _i4.Future<_i2.Either<_i5.Failure, _i8.Category>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, bool>> existsCategoryWithId(String? id) =>
      (super.noSuchMethod(Invocation.method(#existsCategoryWithId, [id]),
              returnValue: Future<_i2.Either<_i5.Failure, bool>>.value(
                  _FakeEither<_i5.Failure, bool>()))
          as _i4.Future<_i2.Either<_i5.Failure, bool>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, void>> insertCategory(
          _i8.Category? category) =>
      (super.noSuchMethod(Invocation.method(#insertCategory, [category]),
              returnValue: Future<_i2.Either<_i5.Failure, void>>.value(
                  _FakeEither<_i5.Failure, void>()))
          as _i4.Future<_i2.Either<_i5.Failure, void>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, bool>> updateCategory(
          _i8.Category? category) =>
      (super.noSuchMethod(Invocation.method(#updateCategory, [category]),
              returnValue: Future<_i2.Either<_i5.Failure, bool>>.value(
                  _FakeEither<_i5.Failure, bool>()))
          as _i4.Future<_i2.Either<_i5.Failure, bool>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, int>> deleteCategoryWithId(String? id) =>
      (super.noSuchMethod(Invocation.method(#deleteCategoryWithId, [id]),
              returnValue: Future<_i2.Either<_i5.Failure, int>>.value(
                  _FakeEither<_i5.Failure, int>()))
          as _i4.Future<_i2.Either<_i5.Failure, int>>);
}
