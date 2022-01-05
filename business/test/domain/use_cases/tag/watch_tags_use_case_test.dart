import 'package:business/business.dart';
import 'package:business/fixtures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '_mock.mocks.dart';

void main() {
  final fix = FixtureTag();
  late ITagRepository repository;
  late WatchTagsUseCase useCase;

  setUp(() {
    repository = MockITagRepository();
    useCase = WatchTagsUseCase(repository);
  });

  test('should return the stream from repository', () async {
    final tag1 = fix.tag1;
    final tag2 = fix.tag2;

    when(repository.watchAll()).thenAnswer((_) {
      return Stream.fromIterable([
        Left(NotFoundFailure()),
        Right([tag1]),
        Right([tag1, tag2]),
      ]);
    });

    await expectLater(
      useCase(),
      emitsInOrder([
        Left(NotFoundFailure()),
        orderedRightEquals([tag1]),
        orderedRightEquals([tag1, tag2]),
      ]),
    );

    verify(repository.watchAll());
    verifyNoMoreInteractions(repository);
  });
}
