import 'package:business/business.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:business/fixtures.dart';

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
