import 'package:business/business.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:business/fixtures.dart';

import '_mock.mocks.dart';

void main() {
  final fix = FixtureSubcategory();
  late ISubcategoryRepository repository;
  late InsertSubcategoryUseCase useCase;

  setUp(() {
    repository = MockISubcategoryRepository();
    useCase = InsertSubcategoryUseCase(repository);
  });

  test('should insert the subcategory on repository', () async {
    final subcategory = fix.subcategory1;

    when(repository.insert(subcategory)).thenAnswer((_) async => Right(Null));

    final result = await useCase(subcategory);

    expect(result, Right(Null));

    verify(repository.insert(subcategory));
    verifyNoMoreInteractions(repository);
  });

  group('$UnknownDatabaseFailure cases', () {
    test(
        'should return $UnknownDatabaseFailure when repository fails '
        'while inserting subcategory', () async {
      final failure = UnknownDatabaseFailure();
      final subcategory = fix.subcategory1;

      when(repository.insert(subcategory)).thenAnswer((_) async => Left(failure));

      final result = await useCase(subcategory);

      expect(result, Left(failure));

      verify(repository.insert(subcategory));
      verifyNoMoreInteractions(repository);
    });
  });
}
