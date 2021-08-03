import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../utils/fixture_subcategory.dart';
import '_mock.mocks.dart';

void main() {
  final fix = FixtureSubcategory();
  late ISubcategoryRepository repository;
  late GetAllSubcategories useCase;

  setUp(() {
    repository = MockISubcategoryRepository();
    useCase = GetAllSubcategories(repository);
  });

  test('should get all subcategories from repository', () async {
    final expected = [fix.subcategory1, fix.subcategory2];

    when(repository.getAllSubcategories()).thenAnswer((_) async => Right(expected));

    final result = await useCase();

    expect(result, Right(expected));

    verify(repository.getAllSubcategories());
    verifyNoMoreInteractions(repository);
  });

  test('should return database failure when repository fails', () async {
    final failure = UnknownDatabaseFailure();

    when(repository.getAllSubcategories()).thenAnswer((_) async => Left(failure));

    final result = await useCase();

    expect(result, Left(failure));

    verify(repository.getAllSubcategories());
    verifyNoMoreInteractions(repository);
  });
}
