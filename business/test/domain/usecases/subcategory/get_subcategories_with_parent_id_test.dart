import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:business/fixtures.dart';

import '_mock.mocks.dart';

void main() {
  final fix = FixtureSubcategory();
  late ISubcategoryRepository repository;
  late GetSubcategoriesWithParentId useCase;

  setUp(() {
    repository = MockISubcategoryRepository();
    useCase = GetSubcategoriesWithParentId(repository);
  });

  test('should get subcategories with parent id from repository', () async {
    final parentId = fix.subcategory1.parent.id;
    final expected = [fix.subcategory1];

    when(repository.getSubcategoriesWithParentId(parentId))
        .thenAnswer((_) async => Right(expected));

    final result = await useCase(parentId);

    expect(result, Right(expected));

    verify(repository.getSubcategoriesWithParentId(parentId));
    verifyNoMoreInteractions(repository);
  });

  test('should return failure when repository fails', () async {
    final parentId = fix.subcategory1.parent.id;
    final failure = UnknownDatabaseFailure();

    when(repository.getSubcategoriesWithParentId(parentId)).thenAnswer((_) async => Left(failure));

    final result = await useCase(parentId);

    expect(result, Left(failure));

    verify(repository.getSubcategoriesWithParentId(parentId));
    verifyNoMoreInteractions(repository);
  });
}
