import 'package:business/business.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:business/fixtures.dart';

import '_mock.mocks.dart';

void main() {
  final fix = FixtureTag();
  late ITagRepository repository;
  late InsertTagUseCase useCase;

  setUp(() {
    repository = MockITagRepository();
    useCase = InsertTagUseCase(repository);
  });

  test('should insert the tag on repository', () async {
    final tag = fix.tag1;

    when(repository.insert(tag)).thenAnswer((_) async => Right(Null));

    final result = await useCase(tag);

    expect(result, Right(Null));

    verify(repository.insert(tag));
    verifyNoMoreInteractions(repository);
  });

  test('should return $UnknownDatabaseFailure when repository fails', () async {
    final failure = UnknownDatabaseFailure();
    final tag = fix.tag1;

    when(repository.insert(tag)).thenAnswer((_) async => Left(failure));

    final result = await useCase(tag);

    expect(result, Left(failure));

    verify(repository.insert(tag));
    verifyNoMoreInteractions(repository);
  });
}
