import 'package:business/business.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:business/fixtures.dart';

import '_mock.mocks.dart';

void main() {
  final fix = FixtureCategory();
  late ICategoryRepository repository;
  late UpdateCategoryUseCase useCase;

  setUp(() {
    repository = MockICategoryRepository();
    useCase = UpdateCategoryUseCase(repository);
  });

  test('should get the category from repository', () async {
    final expected = fix.category1;

    when(repository.update(expected)).thenAnswer((_) async => Right(true));

    final result = await useCase(expected);

    expect(result, Right(true));

    verify(repository.update(expected));
    verifyNoMoreInteractions(repository);
  });

  test('should return database failure when repository fails', () async {
    final failure = UnknownDatabaseFailure();

    when(repository.update(fix.category1)).thenAnswer((_) async => Left(failure));

    final result = await useCase(fix.category1);

    expect(result, Left(failure));

    verify(repository.update(fix.category1));
    verifyNoMoreInteractions(repository);
  });
}
