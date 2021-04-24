import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart' hide isNull;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

import '../utils/fixture_store.dart';

void main() {
  final uid = Uuid();
  late AppDatabase database;
  final fix = FixtureStore();

  setUpAll(() {
    sqfliteFfiInit();
  });

  setUp(() {
    database = AppDatabase(VmDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  group('Insertion', () {
    test('Insertion without name must fail', () async {
      final store = fix.store1.copyWith(name: Value.absent());

      expect(
        () => database.storeDao.insertStore(store),
        throwsA(isA<InvalidDataException>()),
      );

      final fromDb = await database.storeDao.getAllStores();
      expect(fromDb, isEmpty);
    });

    test('Insertion with duplicated id must fail', () async {
      final id = uid.v4();
      final store1 = fix.store1.copyWith(id: Value(id));

      await database.storeDao.insertStore(store1);

      final expected1 = store1.convert();
      var fromDB = await database.storeDao.getAllStores();
      expect(fromDB, orderedEquals([expected1]));

      final store2 = fix.store2.copyWith(id: Value(id));

      expect(
        () => database.storeDao.insertStore(store2),
        throwsA(isA<SqliteException>()),
      );

      // Database is not affected
      fromDB = await database.storeDao.getAllStores();
      expect(fromDB, orderedEquals([expected1]));
    });
  });

  group('Deletion', () {
    test('Simple deletion', () async {
      final store1 = fix.store1;
      final store2 = fix.store2;
      await database.storeDao.insertStore(store1);
      await database.storeDao.insertStore(store2);

      var fromDb = await database.storeDao.getAllStores();
      expect(fromDb, hasLength(2));

      var result = await database.storeDao.deleteStoreWithId(store1.id.value);
      expect(result, 1);

      fromDb = await database.storeDao.getAllStores();
      expect(fromDb, hasLength(1));
    });

    test('Deletion of an item that does not exist', () async {
      final store1 = fix.store1;
      await database.storeDao.insertStore(store1);

      var fromDb = await database.storeDao.getAllStores();
      expect(fromDb, hasLength(1));

      var result = await database.storeDao.deleteStoreWithId(uid.v4());
      expect(result, 0);

      // Database is not affected
      fromDb = await database.storeDao.getAllStores();
      expect(fromDb, hasLength(1));
    });
  });

  group('Query by id', () {
    test('Success cases', () async {
      final store1 = fix.store1;
      final store2 = fix.store2;
      await database.storeDao.insertStore(store1);
      await database.storeDao.insertStore(store2);

      var result = await database.storeDao.getStoreById(store1.id.value);
      var expected = store1.convert();
      expect(result, expected);

      result = await database.storeDao.getStoreById(store2.id.value);
      expected = store2.convert();
      expect(result, expected);
    });

    test('Query by id of an item that does not exist must return null', () async {
      final result = await database.storeDao.getStoreById(uid.v4());
      expect(result, isNull);
    });
  });

  group('Update', () {
    final store1 = fix.store1;
    final store2 = fix.store2;
    final expected1 = store1.convert();
    final expected2 = store2.convert();

    setUp(() async {
      await database.storeDao.insertStore(store1);
      await database.storeDao.insertStore(store2);
    });

    test('Updating name', () async {
      final newName = 'New ${store1.name.value}';
      final newStore = store1.copyWith(name: Value(newName));
      final result = await database.storeDao.updateStore(newStore);
      expect(result, isTrue);

      final fromDb = await database.storeDao.getAllStores();
      final newExpected1 = expected1.copyWith(name: newName);
      expect(fromDb, orderedEquals([newExpected1, expected2]));
    });

    test('Updating an item that does not exist', () async {
      final store = fix.store3;
      final result = await database.storeDao.updateStore(store);
      expect(result, isFalse);

      final fromDb = await database.storeDao.getAllStores();
      // Database is not affected
      expect(fromDb, orderedEquals([expected1, expected2]));
    });
  });
}

extension on StoresCompanion {
  StoreEntity convert({
    String? id,
    String? name,
  }) {
    return StoreEntity(
      id: id ?? this.id.value,
      name: name ?? this.name.value,
    );
  }
}
