import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:business/src/domain/usecases/category/_category.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:business/fixtures.dart';

import '_mock.mocks.dart';

void main() {
  final fix = FixtureCategory();
  late ICategoryRepository repository;
  late InsertCategory useCase;

  setUp(() {
    repository = MockICategoryRepository();
    useCase = InsertCategory(
      repository,
    );
  });

  test('should insert the category on repository', () async {
    final category = fix.category1;

    when(repository.insert(category)).thenAnswer((_) async => Right(Null));

    final result = await useCase(category);

    expect(result, Right(Null));

    verify(repository.insert(category));
    verifyNoMoreInteractions(repository);
  });

  test('should return $UnknownDatabaseFailure when repository fails', () async {
    final failure = UnknownDatabaseFailure();
    final category = fix.category1;

    when(repository.insert(category)).thenAnswer((_) async => Left(failure));

    final result = await useCase(category);

    expect(result, Left(failure));

    verify(repository.insert(category));
    verifyNoMoreInteractions(repository);
  });
}
