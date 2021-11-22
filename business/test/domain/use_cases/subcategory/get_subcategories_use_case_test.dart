import 'package:business/business.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:business/fixtures.dart';

import '_mock.mocks.dart';

void main() {
  final fix = FixtureSubcategory();
  late ISubcategoryRepository repository;
  late GetSubcategoriesUseCase useCase;

  setUp(() {
    repository = MockISubcategoryRepository();
    useCase = GetSubcategoriesUseCase(repository);
  });

  test('should get all subcategories from repository', () async {
    final expected = [fix.subcategory1, fix.subcategory2];

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
