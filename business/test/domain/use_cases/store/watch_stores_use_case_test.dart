import 'package:business/business.dart';
import 'package:business/fixtures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '_mock.mocks.dart';

void main() {
  final fix = FixtureStore();
  late IStoreRepository repository;
  late WatchStoresUseCase useCase;

  setUp(() {
    repository = MockIStoreRepository();
    useCase = WatchStoresUseCase(repository);
  });

  test('should return the stream from repository', () async {
    final store1 = fix.store1;
    final store2 = fix.store2;

    when(repository.watchAll()).thenAnswer((_) {
      return Stream.fromIterable([
        Left(NotFoundFailure()),
        Right([store1]),
        Right([store1, store2]),
      ]);
    });

    await expectLater(
      useCase(),
      emitsInOrder([
        Left(NotFoundFailure()),
        orderedRightEquals([store1]),
        orderedRightEquals([store1, store2]),
      ]),
    );

    verify(repository.watchAll());
    verifyNoMoreInteractions(repository);
  });
}
