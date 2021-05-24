import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../utils/fixture_subcategory.dart';
import '_mock.mocks.dart';

void main() {
  final fix = FixtureSubcategory();
  late MockISubcategoryRepository repository;
  late InsertSubcategory useCase;

  setUp(() {
    repository = MockISubcategoryRepository();
    useCase = InsertSubcategory(repository);
  });

  test('should get the subcategory from repository', () async {
    final expected = fix.subcategory1;

    when(repository.insertSubcategory(expected))
        .thenAnswer((_) async => Right(Null));

    final result = await useCase(expected);

    expect(result, Right(Null));

    verify(repository.insertSubcategory(expected));
    verifyNoMoreInteractions(repository);
  });

  test('should return database failure when repository fails', () async {
    final failure = UnknownDatabaseFailure();

    when(repository.insertSubcategory(fix.subcategory1))
        .thenAnswer((_) async => Left(failure));

    final result = await useCase(fix.subcategory1);

    expect(result, Left(failure));

    verify(repository.insertSubcategory(fix.subcategory1));
    verifyNoMoreInteractions(repository);
  });
}
