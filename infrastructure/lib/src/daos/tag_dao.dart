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

  Future<TagEntity?> getTagById(String id) {
    final query = select(tags)..where((t) => t.id.equals(id));
    return query.getSingleOrNull();
  }

  Future<int> insertTag(Insertable<TagEntity> tag) {
    return into(tags).insert(tag);
  }

  Future<bool> updateTag(Insertable<TagEntity> tag) {
    return update(tags).replace(tag);
  }

  Future<int> deleteTagWithId(String id) {
    final query = delete(tags)..where((t) => t.id.equals(id));
    return query.go();
  }
}
