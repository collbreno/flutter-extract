import 'package:drift/drift.dart';
import 'package:infrastructure/infrastructure.dart';

@DataClassName('TagEntity')
class Tags extends Table {
  TextColumn get id => text().withLength(min: UID_SIZE, max: UID_SIZE)();

  TextColumn get name => text().withLength(min: TAG_NAME_MIN, max: TAG_NAME_MAX)();

  IntColumn get color => integer()();

  TextColumn get iconName => text().nullable().withLength(min: 1, max: ICON_NAME_MAX)();

  TextColumn get iconFamily => text().nullable().withLength(min: 1, max: ICON_PACKAGE_MAX)();

  @override
  Set<Column>? get primaryKey => {id};
}
