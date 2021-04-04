import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

part 'icon_dao.g.dart';

@UseDao(tables: [Icons])
class IconDao extends DatabaseAccessor<AppDatabase> with _$IconDaoMixin {
  final AppDatabase db;

  IconDao(this.db) : super(db);

  Future<List<IconEntity>> getAllIcons() {
    return select(icons).get();
  }

  Future<IconEntity> getIconById(int id) {
    final query = select(icons)..where((i) => i.id.equals(id));
    return query.getSingle();
  }

  Future<int> insertIcon(Insertable<IconEntity> icon) {
    return into(icons).insert(icon);
  }

  Future<bool> updateIcon(Insertable<IconEntity> icon) {
    return update(icons).replace(icon);
  }

  Future<int> deleteIconWithId(int id) {
    final query = delete(icons)..where((i) => i.id.equals(id));
    return query.go();
  }
}
