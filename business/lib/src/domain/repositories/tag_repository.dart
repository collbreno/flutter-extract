import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';

abstract class ITagRepository {
  Future<FailureOr<List<Tag>>> getAll();
  Future<FailureOr<Tag>> getById(String id);
  Future<FailureOr<int>> countUsages(String id);
  Future<FailureOr<void>> insert(Tag tag);
  Future<FailureOr<void>> update(Tag tag);
  Future<FailureOr<void>> delete(String id);
}
