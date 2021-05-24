import 'package:business/src/core/core.dart';
import 'package:business/src/domain/usecases/subcategory/update_subcategory.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../utils/fixture_subcategory.dart';
import '_mock.mocks.dart';

void main() {
  final fix = FixtureSubcategory();
  late MockISubcategoryRepository repository;
  late UpdateSubcategory useCase;

  setUp(() {
    repository = MockISubcategoryRepository();
    useCase = UpdateSubcategory(repository);
  });

  test('should get the subcategory from repository', () async {
    final expected = fix.subcategory1;

    when(repository.updateSubcategory(expected))
        .thenAnswer((_) async => Right(true));

    final result = await useCase(expected);

    expect(result, Right(true));

    verify(repository.updateSubcategory(expected));
    verifyNoMoreInteractions(repository);
  });

  test('should return database failure when repository fails', () async {
    final failure = UnknownDatabaseFailure();

    when(repository.updateSubcategory(fix.subcategory1))
        .thenAnswer((_) async => Left(failure));

    final result = await useCase(fix.subcategory1);

    expect(result, Left(failure));

    verify(repository.updateSubcategory(fix.subcategory1));
    verifyNoMoreInteractions(repository);
  });
}
