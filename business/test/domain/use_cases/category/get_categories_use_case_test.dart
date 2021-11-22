import 'package:business/fixtures.dart';
import 'package:business/business.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '_mock.mocks.dart';

void main() {
  final fix = FixtureCategory();
  late ICategoryRepository repository;
  late GetCategoriesUseCase useCase;

  setUp(() {
    repository = MockICategoryRepository();
    useCase = GetCategoriesUseCase(repository);
  });

  test('should get all categories from repository', () async {
    final expected = [fix.category1, fix.category2];

    when(repository.getAll()).thenAnswer((_) async => Right(expected));

    final result = await useCase();

    expect(result, Right(expected));

    verify(repository.getAll());
    verifyNoMoreInteractions(repository);
  });

  test('should return database failure when repository fails', () async {
    final failure = UnknownDatabaseFailure();

    when(repository.getAll()).thenAnswer((_) async => Left(failure));

    final result = await useCase();

    expect(result, Left(failure));

    verify(repository.getAll());
    verifyNoMoreInteractions(repository);
  });
}
