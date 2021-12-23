import 'package:business/business.dart';
import 'package:business/fixtures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../subcategory/_mock.mocks.dart';

void main() {
  final fix = FixtureCategory();
  late ICategoryRepository repository;
  late WatchAllCategoriesUseCase useCase;

  setUp(() {
    repository = MockICategoryRepository();
    useCase = WatchAllCategoriesUseCase(repository);
  });

  test('should return the stream from repository', () async {
    final category1 = fix.category1;
    final category2 = fix.category2;

    final expected1 = [category1];
    final expected2 = [category1, category2];

    when(repository.watchAll()).thenAnswer((_) {
      return Stream.fromIterable([
        Left(NotFoundFailure()),
        Right(expected1),
        Right(expected2),
      ]);
    });

    await expectLater(
      useCase(),
      emitsInOrder([
        Left(NotFoundFailure()),
        Right(expected1),
        Right(expected2),
      ]),
    );

    verify(repository.watchAll());
    verifyNoMoreInteractions(repository);
  });
}
