import 'package:business/business.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:business/fixtures.dart';

import '_mock.mocks.dart';

void main() {
  final fix = FixtureSubcategory();
  late ISubcategoryRepository repository;
  late GetSubcategoriesFromParentUseCase useCase;

  setUp(() {
    repository = MockISubcategoryRepository();
    useCase = GetSubcategoriesFromParentUseCase(repository);
  });

  test('should get subcategories with parent id from repository', () async {
    final parentId = fix.subcategory1.parent.id;
    final expected = [fix.subcategory1];

    when(repository.getByParentId(parentId))
        .thenAnswer((_) async => Right(expected));

    final result = await useCase(parentId);

    expect(result, Right(expected));

    verify(repository.getByParentId(parentId));
    verifyNoMoreInteractions(repository);
  });

  test('should return failure when repository fails', () async {
    final parentId = fix.subcategory1.parent.id;
    final failure = UnknownDatabaseFailure();

    when(repository.getByParentId(parentId)).thenAnswer((_) async => Left(failure));

    final result = await useCase(parentId);

    expect(result, Left(failure));

    verify(repository.getByParentId(parentId));
    verifyNoMoreInteractions(repository);
  });
}
