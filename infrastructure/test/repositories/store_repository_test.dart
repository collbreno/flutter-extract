import 'package:business/business.dart';
import 'package:business/fixtures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:infrastructure/src/mappers/_mappers.dart';
import 'package:moor/ffi.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

import '../utils/foreign_keys_utils.dart';

void main() {
  final uid = Uuid();
  late StoreRepository repository;
  late AppDatabase database;
  late ForeignKeyUtils fkUtils;
  final fix = FixtureStore();
  final fixExpenses = FixtureExpense();

  setUpAll(() {
    sqfliteFfiInit();
  });

  setUp(() {
    database = AppDatabase(VmDatabase.memory());
    repository = StoreRepository(database);
    fkUtils = ForeignKeyUtils(database);

    addTearDown(() async {
      await database.close();
    });
  });

  test('Get all must return $NotFoundFailure when there is no items in database', () async {
    final fromDB = await repository.getAllStores();

    fromDB.fold(
      (l) => expect(l, NotFoundFailure()),
      (r) => throw Exception('should be left'),
    );
  });

  group('Insertion', () {
    test('Successfully insertion', () async {
      final store = fix.store1;

      await repository.insertStore(store);

      final fromDb = await repository.getAllStores();
      fromDb.fold(
        (l) => throw Exception('should be right'),
        (r) => expect(r, [store]),
      );
    });

    test('Insertion with duplicated id must fail', () async {
      final id = uid.v4();
      final store1 = fix.store1.rebuild((s) => s.id = id);

      var result = await repository.insertStore(store1);
      expect(result, Right(Null));

      var fromDb = await repository.getAllStores();
      fromDb.fold(
        (l) => throw Exception('should be right'),
        (r) => expect(r, [store1]),
      );

      final store2 = fix.store2.rebuild((s) => s.id = id);

      result = await repository.insertStore(store2);
      expect(result, Left(UnknownDatabaseFailure()));

      // Database is not affected
      fromDb = await repository.getAllStores();
      fromDb.fold(
        (l) => throw Exception('should be right'),
        (r) => expect(r, [store1]),
      );
    });
  });

  group('Deletion', () {
    test('Simple deletion', () async {
      final store1 = fix.store1;
      final store2 = fix.store2;
      await repository.insertStore(store1);
      await repository.insertStore(store2);

      var fromDb = await repository.getAllStores();
      fromDb.fold(
        (l) => throw Exception('should be right'),
        (r) => expect(r, [store1, store2]),
      );

      var result = await repository.deleteStoreWithId(store1.id);
      expect(result, Right(Null));

      fromDb = await repository.getAllStores();
      fromDb.fold(
        (l) => throw Exception('should be right'),
        (r) => expect(r, [store2]),
      );
    });

    test('Deletion of an item that does not exist', () async {
      final store1 = fix.store1;
      await repository.insertStore(store1);

      var fromDb = await repository.getAllStores();
      fromDb.fold(
        (l) => throw Exception('should be right'),
        (r) => expect(r, [store1]),
      );

      var result = await repository.deleteStoreWithId(uid.v4());
      expect(result, Left(NothingToDeleteFailure()));

      // Database is not affected
      fromDb = await repository.getAllStores();
      fromDb.fold(
        (l) => throw Exception('should be right'),
        (r) => expect(r, [store1]),
      );
    });
  });

  group('Query by id', () {
    test('Success case', () async {
      final store1 = fix.store1;
      final store2 = fix.store2;
      await repository.insertStore(store1);
      await repository.insertStore(store2);

      var result = await repository.getStoreById(store1.id);
      expect(result, Right(store1));

      result = await repository.getStoreById(store2.id);
      expect(result, Right(store2));
    });

    test('Query by id of an item that does not exist must return $NotFoundFailure', () async {
      final result = await repository.getStoreById(uid.v4());
      expect(result, Left(NotFoundFailure()));
    });
  });

  group('Update', () {
    final store1 = fix.store1;
    final store2 = fix.store2;

    setUp(() async {
      await repository.insertStore(store1);
      await repository.insertStore(store2);
    });

    test('Should return normally when entity has changed', () async {
      final newName = 'New ${store1.name}';
      final newStore = store1.rebuild((s) => s..name = newName);
      final result = await repository.updateStore(newStore);
      expect(result, Right(Null));

      final fromDb = await repository.getAllStores();
      fromDb.fold(
        (l) => throw Exception('should be right'),
        (r) => expect(r, [newStore, store2]),
      );
    });

    test('Should return $NotFoundFailure when entity does not exist', () async {
      final store = fix.store3;
      final result = await repository.updateStore(store);
      expect(result, Left(NotFoundFailure()));

      final fromDb = await repository.getAllStores();
      // Database is not affected
      fromDb.fold(
        (l) => throw Exception('should be right'),
        (r) => expect(r, [store1, store2]),
      );
    });
  });

  test('Count usages', () async {
    final store1 = fix.store1;
    final expense1 = fixExpenses.expense1.toEntity().copyWith(storeId: store1.id);
    final expense2 = fixExpenses.expense2.toEntity().copyWith(storeId: store1.id);

    final store2 = fix.store2;
    final expense3 = fixExpenses.expense3.toEntity().copyWith(storeId: store2.id);

    final store3 = fix.store3;

    await repository.insertStore(store1);
    await repository.insertStore(store2);
    await repository.insertStore(store3);
    await fkUtils.insertExpenseFKDependencies(expense1);
    await fkUtils.insertExpenseFKDependencies(expense2);
    await fkUtils.insertExpenseFKDependencies(expense3);
    await database.into(database.expenses).insert(expense1);
    await database.into(database.expenses).insert(expense2);
    await database.into(database.expenses).insert(expense3);

    var result = await repository.countUsages(store1.id);
    expect(result, Right(2));

    result = await repository.countUsages(store2.id);
    expect(result, Right(1));

    result = await repository.countUsages(store3.id);
    expect(result, Right(0));
  });
}
