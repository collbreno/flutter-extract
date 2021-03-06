import 'package:business/business.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:business/fixtures.dart';

import '_mock.mocks.dart';

void main() {
  final fix = FixtureSubcategory();
  late ISubcategoryRepository repository;
  late DeleteSubcategoryUseCase useCase;

  setUp(() {
    repository = MockISubcategoryRepository();
    useCase = DeleteSubcategoryUseCase(repository);
  });

  test(
      'should delete subcategory from repository '
      'when it is not being used', () async {
    final id = fix.subcategory1.id;

    when(repository.countUsages(id)).thenAnswer((_) async => Right(0));
    when(repository.delete(id)).thenAnswer((_) async => Right(Null));

    final result = await useCase(id);

    expect(result, Right(Null));

    verify(repository.countUsages(id));
    verify(repository.delete(id));
    verifyNoMoreInteractions(repository);
  });

  group('error cases', () {
    test(
        'should return $EntityBeingUsedFailure '
        'when the subcategory is being used', () async {
      final id = fix.subcategory1.id;
      final count = 2;

      when(repository.countUsages(id)).thenAnswer((_) async => Right(count));

      final result = await useCase(id);

      expect(result, Left(EntityBeingUsedFailure(count)));

      verify(repository.countUsages(id));
      verifyNoMoreInteractions(repository);
    });

    test(
        'should return database failure when repository fails '
        'while checking subcategory usages', () async {
      final failure = UnknownDatabaseFailure();
      final id = fix.subcategory1.id;

      when(repository.countUsages(id))
          .thenAnswer((_) async => Left(failure));

      final result = await useCase(id);

      expect(result, Left(failure));

      verify(repository.countUsages(id));
      verifyNoMoreInteractions(repository);
    });

    test(
        'should return database failure when repository fails'
        'while deleting subcategory', () async {
      final failure = UnknownDatabaseFailure();
      final id = fix.subcategory1.id;

      when(repository.countUsages(id)).thenAnswer((_) async => Right(0));
      when(repository.delete(id)).thenAnswer((_) async => Left(failure));

      final result = await useCase(id);

      expect(result, Left(failure));

      verify(repository.countUsages(id));
      verify(repository.delete(id));
      verifyNoMoreInteractions(repository);
    });
  });
}
