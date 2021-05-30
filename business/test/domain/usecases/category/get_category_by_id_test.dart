import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/usecases/category/_category.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../utils/fixture_category.dart';
import '_mock.mocks.dart';

void main() {
  final fix = FixtureCategory();
  late ICategoryRepository repository;
  late GetCategoryById useCase;

  setUp(() {
    repository = MockICategoryRepository();
    useCase = GetCategoryById(repository);
  });

  test('should get the category from repository', () async {
    final expected = fix.category1;

    when(repository.getCategoryById(expected.id)).thenAnswer((_) async => Right(expected));

    final result = await useCase(expected.id);

    expect(result, Right(expected));

    verify(repository.getCategoryById(expected.id));
    verifyNoMoreInteractions(repository);
  });

  test('should return database failure when repository fails', () async {
    final id = 'test';
    final failure = UnknownDatabaseFailure();

    when(repository.getCategoryById(id)).thenAnswer((_) async => Left(failure));

    final result = await useCase(id);

    expect(result, Left(failure));

    verify(repository.getCategoryById(id));
    verifyNoMoreInteractions(repository);
  });
}
