import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';

abstract class ITagRepository {
  Future<FailureOr<List<Tag>>> getAllTags();
  Future<FailureOr<Tag>> getTagById(String id);
  Future<FailureOr<int>> countExpensesWithTagWithId(String id);
  Future<FailureOr<void>> insertTag(Tag tag);
  Future<FailureOr<bool>> updateTag(Tag tag);
  Future<FailureOr<void>> deleteTagWithId(String id);
}
