import 'package:business/business.dart';
import 'package:business/fixtures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '_mock.mocks.dart';

void main() {
  final fix = FixtureTag();
  late ITagRepository repository;
  late WatchTagByIdUseCase useCase;

  setUp(() {
    repository = MockITagRepository();
    useCase = WatchTagByIdUseCase(repository);
  });

  test('should return the stream from repository', () async {
    final tag = fix.tag1;

    when(repository.watchById(tag.id)).thenAnswer((_) {
      return Stream.fromIterable([
        Right(tag),
        Left(NotFoundFailure()),
      ]);
    });

    final expectation = expectLater(
      useCase(tag.id),
      emitsInOrder([
        Right(tag),
        Left(NotFoundFailure()),
      ]),
    );

    await expectation;

    verify(repository.watchById(tag.id));
    verifyNoMoreInteractions(repository);
  });
}
