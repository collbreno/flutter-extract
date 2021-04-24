import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart' hide isNull;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

import '../utils/fixture_tag.dart';
import '../utils/foreign_keys_utils.dart';

void main() {
  final uid = Uuid();
  late AppDatabase database;
  late ForeignKeyUtils fkUtils;
  final fix = FixtureTag();

  setUpAll(() {
    sqfliteFfiInit();
  });

  setUp(() {
    database = AppDatabase(VmDatabase.memory());
    fkUtils = ForeignKeyUtils(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('Insertion', () {
    test('Insertion without id must fail', () async {
      final tag = fix.tag1.copyWith(id: Value.absent());

      await fkUtils.insertTagFKDependencies(tag);
      expect(
        () => database.tagDao.insertTag(tag),
        throwsA(isA<InvalidDataException>()),
      );

      final fromDb = await database.tagDao.getAllTags();
      expect(fromDb, isEmpty);
    });

    test('Insertion without name must fail', () async {
      final tag = fix.tag1.copyWith(name: Value.absent());

      await fkUtils.insertTagFKDependencies(tag);
      expect(
        () => database.tagDao.insertTag(tag),
        throwsA(isA<InvalidDataException>()),
      );

      final fromDb = await database.tagDao.getAllTags();
      expect(fromDb, isEmpty);
    });

    test('Insertion without color must fail', () async {
      final tag = fix.tag1.copyWith(color: Value.absent());

      await fkUtils.insertTagFKDependencies(tag);
      expect(
        () => database.tagDao.insertTag(tag),
        throwsA(isA<InvalidDataException>()),
      );

      final fromDb = await database.tagDao.getAllTags();
      expect(fromDb, isEmpty);
    });

    test('Insertion without iconId must define iconId as null', () async {
      final tag = fix.tag1.copyWith(iconId: Value.absent());

      await fkUtils.insertTagFKDependencies(tag);
      await database.tagDao.insertTag(tag);

      final fromDb = await database.tagDao.getAllTags();
      final expected = tag.convert();

      expect(fromDb, orderedEquals([expected]));
    });

    test('Insertion with duplicated id must fail', () async {
      final id = uid.v4();
      final tag1 = fix.tag1.copyWith(id: Value(id));

      await fkUtils.insertTagFKDependencies(tag1);
      await database.tagDao.insertTag(tag1);

      final expected1 = tag1.convert();
      var fromDB = await database.tagDao.getAllTags();
      expect(fromDB, orderedEquals([expected1]));

      final tag2 = fix.tag2.copyWith(id: Value(id));

      await fkUtils.insertTagFKDependencies(tag2);
      expect(
        () => database.tagDao.insertTag(tag2),
        throwsA(isA<SqliteException>()),
      );

      // Database is not affected
      fromDB = await database.tagDao.getAllTags();
      expect(fromDB, orderedEquals([expected1]));
    });
  });

  group('Foreign keys', () {
    test(
        'Insertion with iconId that does not have any reference '
        'to the icon table must fail.', () async {
      final tag = fix.tag1;

      final iconFromDb = await database.iconDao.getIconById(tag.iconId.value!);
      expect(iconFromDb, isNull);

      expect(
        () => database.tagDao.insertTag(tag),
        throwsA(isA<SqliteException>()),
      );
    });
  });

  group('Deletion', () {
    test('Simple deletion', () async {
      final tag1 = fix.tag1;
      final tag2 = fix.tag2;
      await fkUtils.insertTagFKDependencies(tag1);
      await fkUtils.insertTagFKDependencies(tag2);
      await database.tagDao.insertTag(tag1);
      await database.tagDao.insertTag(tag2);

      var fromDb = await database.tagDao.getAllTags();
      expect(fromDb, hasLength(2));

      var result = await database.tagDao.deleteTagWithId(tag1.id.value);
      expect(result, 1);

      fromDb = await database.tagDao.getAllTags();
      expect(fromDb, hasLength(1));
    });

    test('Deletion of an item that does not exist', () async {
      final tag1 = fix.tag1;
      await fkUtils.insertTagFKDependencies(tag1);
      await database.tagDao.insertTag(tag1);

      var fromDb = await database.tagDao.getAllTags();
      expect(fromDb, hasLength(1));

      var result = await database.tagDao.deleteTagWithId(uid.v4());
      expect(result, 0);

      // Database is not affected
      fromDb = await database.tagDao.getAllTags();
      expect(fromDb, hasLength(1));
    });
  });

  group('Query by id', () {
    test('Success cases', () async {
      final tag1 = fix.tag1;
      final tag2 = fix.tag2;
      await fkUtils.insertTagFKDependencies(tag1);
      await fkUtils.insertTagFKDependencies(tag2);
      await database.tagDao.insertTag(tag1);
      await database.tagDao.insertTag(tag2);

      var result = await database.tagDao.getTagById(tag1.id.value);
      var expected = tag1.convert();
      expect(result, expected);

      result = await database.tagDao.getTagById(tag2.id.value);
      expected = tag2.convert();
      expect(result, expected);
    });

    test('Query by id of an item that does not exist must return null', () async {
      final result = await database.tagDao.getTagById(uid.v4());
      expect(result, isNull);
    });
  });

  group('Update', () {
    final tag1 = fix.tag1;
    final tag2 = fix.tag2;
    final expected1 = tag1.convert();
    final expected2 = tag2.convert();

    setUp(() async {
      await fkUtils.insertTagFKDependencies(tag1);
      await database.tagDao.insertTag(tag1);
      await fkUtils.insertTagFKDependencies(tag2);
      await database.tagDao.insertTag(tag2);
    });

    test('Updating name', () async {
      final newName = 'New ${tag1.name.value}';
      final newTag = tag1.copyWith(name: Value(newName));
      final result = await database.tagDao.updateTag(newTag);
      expect(result, isTrue);

      final fromDb = await database.tagDao.getAllTags();
      final newExpected1 = expected1.copyWith(name: newName);
      expect(fromDb, orderedEquals([newExpected1, expected2]));
    });

    test('Updating iconId', () async {
      final newIconId = uid.v4();
      final newTag = tag1.copyWith(iconId: Value(newIconId));
      await fkUtils.insertTagFKDependencies(newTag);
      final result = await database.tagDao.updateTag(newTag);
      expect(result, isTrue);

      final fromDb = await database.tagDao.getAllTags();
      final newExpected1 = expected1.copyWith(iconId: newIconId);
      expect(fromDb, orderedEquals([newExpected1, expected2]));
    });

    test('Updating color', () async {
      final newColor = tag1.color.value + 1;
      final newTag = tag1.copyWith(color: Value(newColor));
      await fkUtils.insertTagFKDependencies(newTag);
      final result = await database.tagDao.updateTag(newTag);
      expect(result, isTrue);

      final fromDb = await database.tagDao.getAllTags();
      final newExpected1 = expected1.copyWith(color: newColor);
      expect(fromDb, orderedEquals([newExpected1, expected2]));
    });

    test('Updating an item that does not exist', () async {
      final tag = fix.tag3;
      final result = await database.tagDao.updateTag(tag);
      expect(result, isFalse);

      final fromDb = await database.tagDao.getAllTags();
      // Database is not affected
      expect(fromDb, orderedEquals([expected1, expected2]));
    });
  });
}

extension on TagsCompanion {
  TagEntity convert({
    String? id,
    String? iconId,
    int? color,
    String? name,
  }) {
    return TagEntity(
      id: id ?? this.id.value,
      iconId: iconId ?? this.iconId.value,
      color: color ?? this.color.value,
      name: name ?? this.name.value,
    );
  }
}
