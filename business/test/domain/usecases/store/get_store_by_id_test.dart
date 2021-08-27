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
  late GetStoreByIdUseCase useCase;

  setUp(() {
    repository = MockIStoreRepository();
    useCase = GetStoreByIdUseCase(repository);
  });

  test('should get the store from repository', () async {
    final expected = fix.store1;

    when(repository.getStoreById(expected.id)).thenAnswer((_) async => Right(expected));

    final result = await useCase(expected.id);

    expect(result, Right(expected));

    verify(repository.getStoreById(expected.id));
    verifyNoMoreInteractions(repository);
  });

  test('should return database failure when repository fails', () async {
    final id = 'test';
    final failure = UnknownDatabaseFailure();

    when(repository.getStoreById(id)).thenAnswer((_) async => Left(failure));

    final result = await useCase(id);

    expect(result, Left(failure));

    verify(repository.getStoreById(id));
    verifyNoMoreInteractions(repository);
  });
}
