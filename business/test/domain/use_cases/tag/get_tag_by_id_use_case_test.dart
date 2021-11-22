import 'package:business/business.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:business/fixtures.dart';

import '_mock.mocks.dart';

void main() {
  final fix = FixtureTag();
  late ITagRepository repository;
  late GetTagByIdUseCase useCase;

  setUp(() {
    repository = MockITagRepository();
    useCase = GetTagByIdUseCase(repository);
  });

  test('should get the tag from repository', () async {
    final expected = fix.tag1;

    when(repository.getById(expected.id)).thenAnswer((_) async => Right(expected));

    final result = await useCase(expected.id);

    expect(result, Right(expected));

    verify(repository.getById(expected.id));
    verifyNoMoreInteractions(repository);
  });

  test('should return database failure when repository fails', () async {
    final id = 'test';
    final failure = UnknownDatabaseFailure();

    when(repository.getById(id)).thenAnswer((_) async => Left(failure));

    final result = await useCase(id);

    expect(result, Left(failure));

    verify(repository.getById(id));
    verifyNoMoreInteractions(repository);
  });
}
