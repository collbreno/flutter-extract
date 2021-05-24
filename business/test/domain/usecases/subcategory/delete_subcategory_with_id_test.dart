import 'package:business/src/core/core.dart';
import 'package:business/src/domain/usecases/subcategory/delete_subcategory_with_id.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../utils/fixture_subcategory.dart';
import '_mock.mocks.dart';

void main() {
  final fix = FixtureSubcategory();
  late MockISubcategoryRepository repository;
  late DeleteSubcategoryWithId useCase;

  setUp(() {
    repository = MockISubcategoryRepository();
    useCase = DeleteSubcategoryWithId(repository);
  });

  test(
      'should delete subcategory from repository '
      'when it is not being used', () async {
    final id = fix.subcategory1.id;

    when(repository.countExpensesWithSubcategoryWithId(id))
        .thenAnswer((_) async => Right(0));
    when(repository.deleteSubcategoryWithId(id))
        .thenAnswer((_) async => Right(1));

    final result = await useCase(id);

    expect(result, Right(Null));

    verify(repository.countExpensesWithSubcategoryWithId(id));
    verify(repository.deleteSubcategoryWithId(id));
    verifyNoMoreInteractions(repository);
  });

  test(
      'should return $EntityBeingUsedFailure '
      'when the subcategory is being used', () async {
    final id = fix.subcategory1.id;
    final count = 2;

    when(repository.countExpensesWithSubcategoryWithId(id))
        .thenAnswer((_) async => Right(count));

    final result = await useCase(id);

    expect(result, Left(EntityBeingUsedFailure(count)));

    verify(repository.countExpensesWithSubcategoryWithId(id));
    verifyNoMoreInteractions(repository);
  });

  test(
      'should return $NothingToDeleteFailure '
      'when the subcategory does not exist', () async {
    final id = fix.subcategory1.id;

    when(repository.countExpensesWithSubcategoryWithId(id))
        .thenAnswer((_) async => Right(0));
    when(repository.deleteSubcategoryWithId(id))
        .thenAnswer((_) async => Right(0));

    final result = await useCase(id);

    expect(result, Left(NothingToDeleteFailure()));

    verify(repository.countExpensesWithSubcategoryWithId(id));
    verify(repository.deleteSubcategoryWithId(id));
    verifyNoMoreInteractions(repository);
  });

  test(
      'should return database failure when repository fails '
      'while checking subcategory usages', () async {
    final failure = UnknownDatabaseFailure();
    final id = fix.subcategory1.id;

    when(repository.countExpensesWithSubcategoryWithId(id))
        .thenAnswer((_) async => Left(failure));

    final result = await useCase(id);

    expect(result, Left(failure));

    verify(repository.countExpensesWithSubcategoryWithId(id));
    verifyNoMoreInteractions(repository);
  });

  test(
      'should return database failure when repository fails'
      'while deleting subcategory', () async {
    final failure = UnknownDatabaseFailure();
    final id = fix.subcategory1.id;

    when(repository.countExpensesWithSubcategoryWithId(id))
        .thenAnswer((_) async => Right(0));
    when(repository.deleteSubcategoryWithId(id))
        .thenAnswer((_) async => Left(failure));

    final result = await useCase(id);

    expect(result, Left(failure));

    verify(repository.countExpensesWithSubcategoryWithId(id));
    verify(repository.deleteSubcategoryWithId(id));
    verifyNoMoreInteractions(repository);
  });
}
