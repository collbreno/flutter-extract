import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../utils/fixture_subcategory.dart';
import '_mock.mocks.dart';

void main() {
  final fix = FixtureSubcategory();
  late MockISubcategoryRepository subcategoryRepository;
  late MockICategoryRepository categoryRepository;
  late InsertSubcategory useCase;

  setUp(() {
    subcategoryRepository = MockISubcategoryRepository();
    categoryRepository = MockICategoryRepository();
    useCase = InsertSubcategory(
      subcategoryRepository: subcategoryRepository,
      categoryRepository: categoryRepository,
    );
  });

  test(
      'should return $EntityDependencyFailure when there is no '
      'category with parent id in the repository', () async {
    final failure = EntityDependencyFailure();
    final subcategory = fix.subcategory1;

    when(categoryRepository.existsCategoryWithId(subcategory.parent.id))
        .thenAnswer((_) async => Right(false));

    final result = await useCase(subcategory);

    expect(result, Left(failure));

    verify(categoryRepository.existsCategoryWithId(subcategory.parent.id));
    verifyNoMoreInteractions(categoryRepository);
    verifyNoMoreInteractions(subcategoryRepository);
  });

  test(
      'should insert the subcategory on repository when there is '
      'a category with parent id in the repository', () async {
    final subcategory = fix.subcategory1;

    when(categoryRepository.existsCategoryWithId(subcategory.parent.id))
        .thenAnswer((_) async => Right(true));
    when(subcategoryRepository.insertSubcategory(subcategory)).thenAnswer((_) async => Right(Null));

    final result = await useCase(subcategory);

    expect(result, Right(Null));

    verify(categoryRepository.existsCategoryWithId(subcategory.parent.id));
    verify(subcategoryRepository.insertSubcategory(subcategory));
    verifyNoMoreInteractions(categoryRepository);
    verifyNoMoreInteractions(subcategoryRepository);
  });

  group('$UnknownDatabaseFailure cases', () {
    test(
        'should return $UnknownDatabaseFailure when repository fails '
        'while checking if parent exists', () async {
      final failure = UnknownDatabaseFailure();
      final subcategory = fix.subcategory1;

      when(categoryRepository.existsCategoryWithId(subcategory.parent.id))
          .thenAnswer((_) async => Left(failure));

      final result = await useCase(subcategory);

      expect(result, Left(failure));

      verify(categoryRepository.existsCategoryWithId(subcategory.parent.id));
      verifyNoMoreInteractions(categoryRepository);
      verifyNoMoreInteractions(subcategoryRepository);
    });

    test(
        'should return $UnknownDatabaseFailure when repository fails '
        'while inserting subcategory', () async {
      final failure = UnknownDatabaseFailure();
      final subcategory = fix.subcategory1;

      when(categoryRepository.existsCategoryWithId(subcategory.parent.id))
          .thenAnswer((_) async => Right(true));
      when(subcategoryRepository.insertSubcategory(subcategory))
          .thenAnswer((_) async => Left(failure));

      final result = await useCase(subcategory);

      expect(result, Left(failure));

      verify(categoryRepository.existsCategoryWithId(subcategory.parent.id));
      verify(subcategoryRepository.insertSubcategory(subcategory));
      verifyNoMoreInteractions(categoryRepository);
      verifyNoMoreInteractions(subcategoryRepository);
    });
  });
}
