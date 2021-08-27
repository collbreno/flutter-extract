import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:business/src/domain/usecases/category/_category.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../utils/fixture_category.dart';
import '_mock.mocks.dart';

void main() {
  final fix = FixtureCategory();
  late ICategoryRepository repository;
  late UpdateCategory useCase;

  setUp(() {
    repository = MockICategoryRepository();
    useCase = UpdateCategory(repository);
  });

  test('should get the category from repository', () async {
    final expected = fix.category1;

    when(repository.updateCategory(expected)).thenAnswer((_) async => Right(true));

    final result = await useCase(expected);

    expect(result, Right(true));

    verify(repository.updateCategory(expected));
    verifyNoMoreInteractions(repository);
  });

  test('should return database failure when repository fails', () async {
    final failure = UnknownDatabaseFailure();

    when(repository.updateCategory(fix.category1)).thenAnswer((_) async => Left(failure));

    final result = await useCase(fix.category1);

    expect(result, Left(failure));

    verify(repository.updateCategory(fix.category1));
    verifyNoMoreInteractions(repository);
  });
}
