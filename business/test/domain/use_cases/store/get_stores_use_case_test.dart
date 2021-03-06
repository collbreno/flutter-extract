import 'package:business/business.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:business/fixtures.dart';

import '_mock.mocks.dart';

void main() {
  final fix = FixtureStore();
  late IStoreRepository repository;
  late GetStoresUseCase useCase;

  setUp(() {
    repository = MockIStoreRepository();
    useCase = GetStoresUseCase(repository);
  });

  test('should get all stores from repository', () async {
    final expected = [fix.store1, fix.store2];

    when(repository.getAll()).thenAnswer((_) async => Right(expected));

    final result = await useCase();

    expect(result, Right(expected));

    verify(repository.getAll());
    verifyNoMoreInteractions(repository);
  });

  test('should return database failure when repository fails', () async {
    final failure = UnknownDatabaseFailure();

    when(repository.getAll()).thenAnswer((_) async => Left(failure));

    final result = await useCase();

    expect(result, Left(failure));

    verify(repository.getAll());
    verifyNoMoreInteractions(repository);
  });
}
