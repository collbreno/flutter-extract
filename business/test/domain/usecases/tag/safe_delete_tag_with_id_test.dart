import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:business/src/domain/usecases/tag/_tag.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:business/fixtures.dart';

import '_mock.mocks.dart';

void main() {
  final fix = FixtureTag();
  late ITagRepository repository;
  late SafeDeleteTagWithId useCase;

  setUp(() {
    repository = MockITagRepository();
    useCase = SafeDeleteTagWithId(repository);
  });

  test(
      'should delete tag from repository '
      'when it is not being used', () async {
    final id = fix.tag1.id;

    when(repository.countUsages(id)).thenAnswer((_) async => Right(0));
    when(repository.deleteTagWithId(id)).thenAnswer((_) async => Right(Null));

    final result = await useCase(id);

    expect(result, Right(Null));

    verify(repository.countUsages(id));
    verify(repository.deleteTagWithId(id));
    verifyNoMoreInteractions(repository);
  });

  group('error cases', () {
    test(
        'should return $EntityBeingUsedFailure '
        'when the tag is being used', () async {
      final id = fix.tag1.id;
      final count = 2;

      when(repository.countUsages(id)).thenAnswer((_) async => Right(count));

      final result = await useCase(id);

      expect(result, Left(EntityBeingUsedFailure(count)));

      verify(repository.countUsages(id));
      verifyNoMoreInteractions(repository);
    });

    test(
        'should return database failure when repository fails '
        'while checking tag usages', () async {
      final failure = UnknownDatabaseFailure();
      final id = fix.tag1.id;

      when(repository.countUsages(id)).thenAnswer((_) async => Left(failure));

      final result = await useCase(id);

      expect(result, Left(failure));

      verify(repository.countUsages(id));
      verifyNoMoreInteractions(repository);
    });

    test(
        'should return database failure when repository fails'
        'while deleting tag', () async {
      final failure = UnknownDatabaseFailure();
      final id = fix.tag1.id;

      when(repository.countUsages(id)).thenAnswer((_) async => Right(0));
      when(repository.deleteTagWithId(id)).thenAnswer((_) async => Left(failure));

      final result = await useCase(id);

      expect(result, Left(failure));

      verify(repository.countUsages(id));
      verify(repository.deleteTagWithId(id));
      verifyNoMoreInteractions(repository);
    });
  });
}
