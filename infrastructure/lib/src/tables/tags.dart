import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

@DataClassName('TagEntity')
class Tags extends Table {
  TextColumn get id => text().withLength(min: UID_SIZE, max: UID_SIZE)();
  TextColumn get name => text().withLength(min: 1, max: 24)();
  IntColumn get color => integer()();
  TextColumn get iconName => text().nullable().withLength(min: 1, max: ICON_NAME_MAX)();
  TextColumn get iconFamily => text().nullable().withLength(min: 1, max: ICON_PACKAGE_MAX)();

  @override
  Set<Column>? get primaryKey => {id};
}
