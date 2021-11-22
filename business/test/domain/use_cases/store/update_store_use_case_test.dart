import 'package:business/business.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:business/fixtures.dart';

import '_mock.mocks.dart';

void main() {
  final fix = FixtureStore();
  late IStoreRepository repository;
  late UpdateStoreUseCase useCase;

  setUp(() {
    repository = MockIStoreRepository();
    useCase = UpdateStoreUseCase(repository);
  });

  test('should get the store from repository', () async {
    final expected = fix.store1;

    when(repository.update(expected)).thenAnswer((_) async => Right(true));

    final result = await useCase(expected);

    expect(result, Right(true));

    verify(repository.update(expected));
    verifyNoMoreInteractions(repository);
  });

  test('should return database failure when repository fails', () async {
    final failure = UnknownDatabaseFailure();

    when(repository.update(fix.store1)).thenAnswer((_) async => Left(failure));

    final result = await useCase(fix.store1);

    expect(result, Left(failure));

    verify(repository.update(fix.store1));
    verifyNoMoreInteractions(repository);
  });
}
