import 'package:business/src/core/core.dart';
import 'package:business/src/domain/entities/entities.dart';

abstract class ITagRepository {
  Future<FailureOr<List<Tag>>> getAllTags();
  Future<FailureOr<Tag>> getTagById(String id);
  Future<FailureOr<void>> insertTag(Tag tag);
  Future<FailureOr<bool>> updateTag(Tag tag);
  Future<FailureOr<void>> deleteTagWithId(String id);
}
