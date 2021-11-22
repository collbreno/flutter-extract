import 'package:business/business.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:business/fixtures.dart';

import '_mock.mocks.dart';

void main() {
  final fix = FixtureStore();
  late IStoreRepository repository;
  late InsertStoreUseCase useCase;

  setUp(() {
    repository = MockIStoreRepository();
    useCase = InsertStoreUseCase(repository);
  });

  test('should insert the store on repository', () async {
    final store = fix.store1;

    when(repository.insert(store)).thenAnswer((_) async => Right(Null));

    final result = await useCase(store);

    expect(result, Right(Null));

    verify(repository.insert(store));
    verifyNoMoreInteractions(repository);
  });

  test('should return $UnknownDatabaseFailure when repository fails', () async {
    final failure = UnknownDatabaseFailure();
    final store = fix.store1;

    when(repository.insert(store)).thenAnswer((_) async => Left(failure));

    final result = await useCase(store);

    expect(result, Left(failure));

    verify(repository.insert(store));
    verifyNoMoreInteractions(repository);
  });
}
