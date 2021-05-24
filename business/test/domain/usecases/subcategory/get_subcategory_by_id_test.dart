import 'package:business/src/core/core.dart';
import 'package:business/src/domain/usecases/subcategory/get_subcategory_by_id.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../utils/fixture_subcategory.dart';
import '_mock.mocks.dart';

void main() {
  final fix = FixtureSubcategory();
  late MockISubcategoryRepository repository;
  late GetSubcategoryById useCase;

  setUp(() {
    repository = MockISubcategoryRepository();
    useCase = GetSubcategoryById(repository);
  });

  test('should get the subcategory from repository', () async {
    final expected = fix.subcategory1;

    when(repository.getSubcategoryById(expected.id))
        .thenAnswer((_) async => Right(expected));

    final result = await useCase(expected.id);

    expect(result, Right(expected));

    verify(repository.getSubcategoryById(expected.id));
    verifyNoMoreInteractions(repository);
  });

  test('should return database failure when repository fails', () async {
    final id = 'test';
    final failure = UnknownDatabaseFailure();

    when(repository.getSubcategoryById(id))
        .thenAnswer((_) async => Left(failure));

    final result = await useCase(id);

    expect(result, Left(failure));

    verify(repository.getSubcategoryById(id));
    verifyNoMoreInteractions(repository);
  });
}
