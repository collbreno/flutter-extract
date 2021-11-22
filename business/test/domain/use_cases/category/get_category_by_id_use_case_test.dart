import 'package:business/business.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:business/fixtures.dart';

import '_mock.mocks.dart';

void main() {
  final fix = FixtureCategory();
  late ICategoryRepository repository;
  late GetCategoryByIdUseCase useCase;

  setUp(() {
    repository = MockICategoryRepository();
    useCase = GetCategoryByIdUseCase(repository);
  });

  test('should get the category from repository', () async {
    final expected = fix.category1;

    when(repository.getById(expected.id))
        .thenAnswer((_) async => Right(expected));

    final result = await useCase(expected.id);

    expect(result, Right(expected));

    verify(repository.getById(expected.id));
    verifyNoMoreInteractions(repository);
  });

  test('should return database failure when repository fails', () async {
    final id = 'test';
    final failure = UnknownDatabaseFailure();

    when(repository.getById(id)).thenAnswer((_) async => Left(failure));

    final result = await useCase(id);

    expect(result, Left(failure));

    verify(repository.getById(id));
    verifyNoMoreInteractions(repository);
  });
}
