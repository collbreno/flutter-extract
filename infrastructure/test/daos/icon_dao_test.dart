import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart' hide isNull;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

import '../utils/fixture_icon.dart';

void main() {
  final uid = Uuid();
  late AppDatabase database;
  final fix = FixtureIcon();

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
    test('Insertion without id must fail', () async {
      final icon = fix.icon1.copyWith(id: Value.absent());

      expect(
        () => database.iconDao.insertIcon(icon),
        throwsA(isA<InvalidDataException>()),
      );

      final fromDb = await database.iconDao.getAllIcons();
      expect(fromDb, isEmpty);
    });

    test('Insertion without name must fail', () async {
      final icon = fix.icon1.copyWith(name: Value.absent());

      expect(
        () => database.iconDao.insertIcon(icon),
        throwsA(isA<InvalidDataException>()),
      );

      final fromDb = await database.iconDao.getAllIcons();
      expect(fromDb, isEmpty);
    });

    test('Insertion without family must fail', () async {
      final icon = fix.icon1.copyWith(family: Value.absent());

      expect(
        () => database.iconDao.insertIcon(icon),
        throwsA(isA<InvalidDataException>()),
      );

      final fromDb = await database.iconDao.getAllIcons();
      expect(fromDb, isEmpty);
    });

    test('Insertion with duplicated id must fail', () async {
      final id = uid.v4();
      final icon1 = fix.icon1.copyWith(id: Value(id));
      final icon2 = fix.icon2.copyWith(id: Value(id));

      await database.iconDao.insertIcon(icon1);

      final expected1 = IconEntity(
        id: icon1.id.value,
        name: icon1.name.value,
        family: icon1.family.value,
      );
      var fromDb = await database.iconDao.getAllIcons();
      expect(fromDb, orderedEquals([expected1]));

      expect(
        () async => await database.iconDao.insertIcon(icon2),
        throwsA(isA<SqliteException>()),
      );

      // Database is not affected
      fromDb = await database.iconDao.getAllIcons();
      expect(fromDb, orderedEquals([expected1]));
    });
  });

  group('Deletion', () {
    test('Simple deletion', () async {
      final icon = fix.icon1;

      await database.iconDao.insertIcon(icon);

      var fromDb = await database.iconDao.getAllIcons();
      expect(fromDb, hasLength(1));

      final result = await database.iconDao.deleteIconWithId(icon.id.value);
      expect(result, 1);

      fromDb = await database.iconDao.getAllIcons();
      expect(fromDb, isEmpty);
    });

    test('Deletion of an item that does not exist', () async {
      final icon = fix.icon1;
      await database.iconDao.insertIcon(icon);

      var fromDb = await database.iconDao.getAllIcons();
      expect(fromDb, hasLength(1));

      final differentId = uid.v4();
      expect(icon.id.value, isNot(differentId));

      var result = await database.iconDao.deleteIconWithId(differentId);
      expect(result, 0);

      // Database is not affected
      fromDb = await database.iconDao.getAllIcons();
      expect(fromDb, hasLength(1));
    });
  });

  group('Update', () {
    final icon1 = fix.icon1;
    final icon2 = fix.icon2;
    final expected1 = IconEntity(
      id: icon1.id.value,
      name: icon1.name.value,
      family: icon1.family.value,
    );
    final expected2 = IconEntity(
      id: icon2.id.value,
      name: icon2.name.value,
      family: icon2.family.value,
    );

    setUp(() async {
      await database.iconDao.insertIcon(icon1);
      await database.iconDao.insertIcon(icon2);
    });

    test('Updating name', () async {
      final newIcon1 = icon1.copyWith(name: Value('New name'));
      final result = await database.iconDao.updateIcon(newIcon1);
      expect(result, isTrue);

      final fromDb = await database.iconDao.getAllIcons();
      final newExpected1 = expected1.copyWith(name: newIcon1.name.value);
      expect(fromDb, orderedEquals([newExpected1, expected2]));
    });

    test('Updating family', () async {
      final newIcon1 = icon1.copyWith(family: Value('New family'));
      final result = await database.iconDao.updateIcon(newIcon1);
      expect(result, isTrue);

      final fromDb = await database.iconDao.getAllIcons();
      final newExpected1 = expected1.copyWith(family: newIcon1.family.value);
      expect(fromDb, orderedEquals([newExpected1, expected2]));
    });

    test('Updating an item that does not exist', () async {
      final newIcon = fix.icon3;
      final result = await database.iconDao.updateIcon(newIcon);
      expect(result, isFalse);

      final fromDb = await database.iconDao.getAllIcons();
      // Database is not affected
      expect(fromDb, orderedEquals([expected1, expected2]));
    });
  });

  group('Query by id', () {
    test('Success cases', () async {
      final icon1 = fix.icon1;
      final icon2 = fix.icon2;

      await database.iconDao.insertIcon(icon1);
      await database.iconDao.insertIcon(icon2);

      var result = await database.iconDao.getIconById(icon1.id.value);
      var expected = IconEntity(
        id: icon1.id.value,
        family: icon1.family.value,
        name: icon1.name.value,
      );
      expect(result, expected);

      result = await database.iconDao.getIconById(icon2.id.value);
      expected = IconEntity(
        id: icon2.id.value,
        family: icon2.family.value,
        name: icon2.name.value,
      );
      expect(result, expected);
    });

    test('Query by id of an item that does not exist must return null', () async {
      final result = await database.iconDao.getIconById(uid.v4());
      expect(result, isNull);
    });
  });
}
