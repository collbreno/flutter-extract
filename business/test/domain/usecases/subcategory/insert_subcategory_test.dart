import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../utils/fixture_subcategory.dart';
import '_mock.mocks.dart';

void main() {
  final fix = FixtureSubcategory();
  late ISubcategoryRepository subcategoryRepository;
  late ICategoryRepository categoryRepository;
  late InsertSubcategory useCase;

  setUp(() {
    subcategoryRepository = MockISubcategoryRepository();
    categoryRepository = MockICategoryRepository();
    useCase = InsertSubcategory(
      subcategoryRepository: subcategoryRepository,
      categoryRepository: categoryRepository,
    );
  });

  test('should insert the subcategory on repository', () async {
    final subcategory = fix.subcategory1;

    when(subcategoryRepository.insertSubcategory(subcategory)).thenAnswer((_) async => Right(Null));

    final result = await useCase(subcategory);

    expect(result, Right(Null));

    verify(subcategoryRepository.insertSubcategory(subcategory));
    verifyNoMoreInteractions(categoryRepository);
    verifyNoMoreInteractions(subcategoryRepository);
  });

  group('$UnknownDatabaseFailure cases', () {
    test(
        'should return $UnknownDatabaseFailure when repository fails '
        'while inserting subcategory', () async {
      final failure = UnknownDatabaseFailure();
      final subcategory = fix.subcategory1;

      when(subcategoryRepository.insertSubcategory(subcategory))
          .thenAnswer((_) async => Left(failure));

      final result = await useCase(subcategory);

      expect(result, Left(failure));

      verify(subcategoryRepository.insertSubcategory(subcategory));
      verifyNoMoreInteractions(categoryRepository);
      verifyNoMoreInteractions(subcategoryRepository);
    });
  });
}
