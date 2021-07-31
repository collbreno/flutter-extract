import 'package:business/business.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:infrastructure/src/daos/interfaces.dart';
import 'package:infrastructure/src/repositories/store_repository.dart';
import 'package:mockito/mockito.dart';

import '../utils/extensions.dart';
import '../utils/fixture_store.dart';
import '_mock.mocks.dart';

void main() {
  final fix = FixtureStore();
  late IEntityDao<StoreEntity> dao;
  late StoreRepository repository;

  setUp(() {
    dao = MockStoreDao();
    repository = StoreRepository(dao);
  });

  group('get by id', () {
    test('when dao returns normally, repository should return a store', () async {
      final store = fix.store1.convert();
      when(dao.getById(store.id)).thenAnswer((_) async => store);

      final result = await repository.getStoreById(store.id);
      final expected = Store(
        id: store.id,
        name: store.name,
      );

      expect(result, Right(expected));
      verify(dao.getById(store.id));
      verifyNoMoreInteractions(dao);
    });

    test('should return failure when dao throws an exception', () async {
      final store = fix.store1.convert();
      when(dao.getById(store.id)).thenThrow(Exception());

      final result = await repository.getStoreById(store.id);
      final expected = UnknownDatabaseFailure();

      expect(result, Left(expected));
      verify(dao.getById(store.id));
      verifyNoMoreInteractions(dao);
    });

    test('should return $NotFoundFailure when dao returns null', () async {
      final store = fix.store1.convert();
      when(dao.getById(store.id)).thenAnswer((_) async => null);

      final result = await repository.getStoreById(store.id);
      final expected = NotFoundFailure();

      expect(result, Left(expected));

      verify(dao.getById(store.id));
      verifyNoMoreInteractions(dao);
    });
  });

  group('get all', () {
    test('when dao returns normally, should return the list', () async {
      final store1 = fix.store1.convert();
      final store2 = fix.store2.convert();
      when(dao.getAll()).thenAnswer((_) async => [store1, store2]);

      final result = await repository.getAllStores();
      final expected = [
        Store(
          id: store1.id,
          name: store1.name,
        ),
        Store(
          id: store2.id,
          name: store2.name,
        ),
      ];

      // TODO: Refactor this expect
      result.fold(
        (failure) => throw Exception('should not be failure'),
        (result) => expect(result, expected),
      );
      verify(dao.getAll());
      verifyNoMoreInteractions(dao);
    });

    test('when dao throws an exception, should return $UnknownDatabaseFailure', () async {
      when(dao.getAll()).thenThrow(Exception());

      final result = await repository.getAllStores();
      final expected = UnknownDatabaseFailure();

      expect(result, Left(expected));

      verify(dao.getAll());
      verifyNoMoreInteractions(dao);
    });

    test('when dao returns an empty list, should return $NotFoundFailure', () async {
      when(dao.getAll()).thenAnswer((_) async => []);

      final result = await repository.getAllStores();

      expect(result, Left(NotFoundFailure()));
      verify(dao.getAll());
      verifyNoMoreInteractions(dao);
    });
  });

  group('insert store', () {
    test('when dao returns normally, should return nothing', () async {
      final store = fix.store1.convert();
      when(dao.insert(store)).thenAnswer((_) async => 1);

      final result = await repository.insertStore(Store(name: store.name, id: store.id));

      expect(result, Right(Null));
      verify(dao.insert(store));
      verifyNoMoreInteractions(dao);
    });

    test('when dao throws an exception, should return $UnknownDatabaseFailure', () async {
      final store = fix.store1.convert();
      when(dao.insert(store)).thenThrow(Exception());

      final result = await repository.insertStore(Store(name: store.name, id: store.id));
      final expected = UnknownDatabaseFailure();

      expect(result, Left(expected));

      verify(dao.insert(store));
      verifyNoMoreInteractions(dao);
    });
  });

  group('delete store', () {
    test('when dao returns normally, should return nothing', () async {
      final store = fix.store1.convert();
      when(dao.deleteWithId(store.id)).thenAnswer((_) async => 1);

      final result = await repository.deleteStoreWithId(store.id);

      expect(result, Right(Null));
      verify(dao.deleteWithId(store.id));
      verifyNoMoreInteractions(dao);
    });

    test('when dao throws an exception, should return $UnknownDatabaseFailure', () async {
      final store = fix.store1.convert();
      when(dao.deleteWithId(store.id)).thenThrow(Exception());

      final result = await repository.deleteStoreWithId(store.id);
      final expected = UnknownDatabaseFailure();

      expect(result, Left(expected));

      verify(dao.deleteWithId(store.id));
      verifyNoMoreInteractions(dao);
    });

    test('when dao returns zero, should $NothingToDeleteFailure', () async {
      final store = fix.store1.convert();
      when(dao.deleteWithId(store.id)).thenAnswer((_) async => 0);

      final result = await repository.deleteStoreWithId(store.id);

      expect(result, Left(NothingToDeleteFailure()));
      verify(dao.deleteWithId(store.id));
      verifyNoMoreInteractions(dao);
    });
  });

  group('update store', () {
    test('when dao returns true, should return true', () async {
      final store = fix.store1.convert();
      when(dao.updateWithId(store)).thenAnswer((_) async => true);

      final result = await repository.updateStore(Store(id: store.id, name: store.name));

      expect(result, Right(true));
      verify(dao.updateWithId(store));
      verifyNoMoreInteractions(dao);
    });

    test('when dao returns false, should return false', () async {
      final store = fix.store1.convert();
      when(dao.updateWithId(store)).thenAnswer((_) async => false);

      final result = await repository.updateStore(Store(id: store.id, name: store.name));

      expect(result, Right(false));
      verify(dao.updateWithId(store));
      verifyNoMoreInteractions(dao);
    });

    test('when dao throws an exception, should return $UnknownDatabaseFailure', () async {
      final store = fix.store1.convert();
      when(dao.updateWithId(store)).thenThrow(Exception());

      final result = await repository.updateStore(Store(id: store.id, name: store.name));
      final expected = UnknownDatabaseFailure();

      expect(result, Left(expected));

      verify(dao.updateWithId(store));
      verifyNoMoreInteractions(dao);
    });
  });
}
