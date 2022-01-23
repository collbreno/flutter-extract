import 'package:business/business.dart';
import 'package:business/fixtures.dart';
import 'package:business/src/domain/use_cases/subcategory/watch_subcategories_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '_mock.mocks.dart';

void main() {
  final fix = FixtureSubcategory();
  late ISubcategoryRepository repository;
  late WatchSubcategoriesUseCase useCase;

  setUp(() {
    repository = MockISubcategoryRepository();
    useCase = WatchSubcategoriesUseCase(repository);
  });

  test('should return the stream from repository', () async {
    final subcategory1 = fix.subcategory1;
    final subcategory2 = fix.subcategory2;

    when(repository.watchAll()).thenAnswer((_) {
      return Stream.fromIterable([
        Left(NotFoundFailure()),
        Right([subcategory1]),
        Right([subcategory1, subcategory2]),
      ]);
    });

    await expectLater(
      useCase(),
      emitsInOrder([
        Left(NotFoundFailure()),
        orderedRightEquals([subcategory1]),
        orderedRightEquals([subcategory1, subcategory2]),
      ]),
    );

    verify(repository.watchAll());
    verifyNoMoreInteractions(repository);
  });
}
