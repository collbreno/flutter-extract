import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../utils/fixture_store.dart';
import '_mock.mocks.dart';

void main() {
  final fix = FixtureStore();
  late IStoreRepository repository;
  late GetAllStoresUseCase useCase;

  setUp(() {
    repository = MockIStoreRepository();
    useCase = GetAllStoresUseCase(repository);
  });

  test('should get all stores from repository', () async {
    final expected = [fix.store1, fix.store2];

    when(repository.getAllStores()).thenAnswer((_) async => Right(expected));

    final result = await useCase();

    expect(result, Right(expected));

    verify(repository.getAllStores());
    verifyNoMoreInteractions(repository);
  });

  test('should return database failure when repository fails', () async {
    final failure = UnknownDatabaseFailure();

    when(repository.getAllStores()).thenAnswer((_) async => Left(failure));

    final result = await useCase();

    expect(result, Left(failure));

    verify(repository.getAllStores());
    verifyNoMoreInteractions(repository);
  });
}
