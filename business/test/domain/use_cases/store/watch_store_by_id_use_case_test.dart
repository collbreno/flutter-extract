import 'package:business/business.dart';
import 'package:business/fixtures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '_mock.mocks.dart';

void main() {
  final fix = FixtureStore();
  late IStoreRepository repository;
  late WatchStoreByIdUseCase useCase;

  setUp(() {
    repository = MockIStoreRepository();
    useCase = WatchStoreByIdUseCase(repository);
  });

  test('should return the stream from repository', () async {
    final store = fix.store1;

    when(repository.watchById(store.id)).thenAnswer((_) {
      return Stream.fromIterable([
        Right(store),
        Left(NotFoundFailure()),
      ]);
    });

    final expectation = expectLater(
      useCase(store.id),
      emitsInOrder([
        Right(store),
        Left(NotFoundFailure()),
      ]),
    );

    await expectation;

    verify(repository.watchById(store.id));
    verifyNoMoreInteractions(repository);
  });
}
