import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:business/fixtures.dart';

import '_mock.mocks.dart';

void main() {
  final fix = FixtureStore();
  late IStoreRepository repository;
  late ForceDeleteStoreUseCase useCase;

  setUp(() {
    repository = MockIStoreRepository();
    useCase = ForceDeleteStoreUseCase(repository);
  });

  test('should delete the store from repository', () async {
    final id = fix.store1.id;

    when(repository.delete(id)).thenAnswer((_) async => Right(Null));

    final result = await useCase(id);

    expect(result, Right(Null));

    verify(repository.delete(id));
    verifyNoMoreInteractions(repository);
  });

  test('should return $DatabaseFailure when the repository fails', () async {
    final failure = UnknownDatabaseFailure();
    final id = fix.store1.id;

    when(repository.delete(id)).thenAnswer((_) async => Left(failure));

    final result = await useCase(id);

    expect(result, Left(failure));

    verify(repository.delete(id));
    verifyNoMoreInteractions(repository);
  });
}
