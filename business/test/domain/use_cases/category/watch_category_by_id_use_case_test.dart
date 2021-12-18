import 'package:business/business.dart';
import 'package:business/fixtures.dart';
import 'package:business/src/domain/use_cases/category/watch_category_by_id_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '_mock.mocks.dart';

void main() {
  final fix = FixtureCategory();
  late ICategoryRepository repository;
  late WatchCategoryByIdUseCase useCase;

  setUp(() {
    repository = MockICategoryRepository();
    useCase = WatchCategoryByIdUseCase(repository);
  });

  test('should return the stream from repository', () async {
    final category = fix.category1;

    when(repository.watchById(category.id)).thenAnswer((_) {
      return Stream.fromIterable([
        Right(category),
        Left(NotFoundFailure()),
      ]);
    });

    final expectation = expectLater(
      useCase(category.id),
      emitsInOrder([
        Right(category),
        Left(NotFoundFailure()),
      ]),
    );

    await expectation;

    verify(repository.watchById(category.id));
    verifyNoMoreInteractions(repository);
  });
}
