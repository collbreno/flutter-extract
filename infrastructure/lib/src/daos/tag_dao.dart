import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

part 'tag_dao.g.dart';

@UseDao(tables: [Tags])
class TagDao extends DatabaseAccessor<AppDatabase> with _$TagDaoMixin {
  final AppDatabase db;

  TagDao(this.db) : super(db);

  Future<List<TagEntity>> getAllTags() {
    return select(tags).get();
  }

  Future<TagEntity> getTagById(int id) {
    final query = select(tags)..where((t) => t.id.equals(id));
    return query.getSingle();
  }

  Future<int> insertTag(Insertable<TagEntity> tag) {
    return into(tags).insert(tag);
  }

  Future<bool> updateTag(Insertable<TagEntity> tag) {
    return update(tags).replace(tag);
  }

  Future<int> deleteTagWithId(int id) {
    final query = delete(tags)..where((t) => t.id.equals(id));
    return query.go();
  }

}
