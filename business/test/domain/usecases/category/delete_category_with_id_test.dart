import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:business/src/domain/usecases/category/_category.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../utils/fixture_category.dart';
import '_mock.mocks.dart';

void main() {
  final fix = FixtureCategory();
  late ICategoryRepository repository;
  late DeleteCategoryWithId useCase;

  setUp(() {
    repository = MockICategoryRepository();
    useCase = DeleteCategoryWithId(repository);
  });

  test(
      'should delete category from repository '
      'when it is not being used', () async {
    final id = fix.category1.id;

    when(repository.countUsages(id)).thenAnswer((_) async => Right(0));
    when(repository.deleteCategory(id)).thenAnswer((_) async => Right(Null));

    final result = await useCase(id);

    expect(result, Right(Null));

    verify(repository.countUsages(id));
    verify(repository.deleteCategory(id));
    verifyNoMoreInteractions(repository);
  });

  group('error cases', () {
    test(
        'should return $EntityBeingUsedFailure '
        'when the category is being used', () async {
      final id = fix.category1.id;
      final usages = 3;

      when(repository.countUsages(id)).thenAnswer((_) async => Right(usages));

      final result = await useCase(id);

      expect(result, Left(EntityBeingUsedFailure(usages)));

      verify(repository.countUsages(id));
      verifyNoMoreInteractions(repository);
    });

    test(
        'should return database failure when repository fails '
        'while checking category usages', () async {
      final id = fix.category1.id;
      final failure = UnknownDatabaseFailure();

      when(repository.countUsages(id)).thenAnswer((_) async => Left(failure));

      final result = await useCase(id);

      expect(result, Left(failure));

      verify(repository.countUsages(id));
      verifyNoMoreInteractions(repository);
    });

    test(
        'should return database failure when repository fails '
        'while deleting category', () async {
      final id = fix.category1.id;
      final failure = UnknownDatabaseFailure();

      when(repository.countUsages(id)).thenAnswer((_) async => Right(0));
      when(repository.deleteCategory(id)).thenAnswer((_) async => Left(failure));

      final result = await useCase(id);

      expect(result, Left(failure));

      verify(repository.countUsages(id));
      verify(repository.deleteCategory(id));
      verifyNoMoreInteractions(repository);
    });
  });
}
