import 'package:business/business.dart';

abstract class ITagRepository {
  Future<FailureOr<List<Tag>>> getAll();
  Future<FailureOr<Tag>> getById(String id);
  Future<FailureOr<int>> countUsages(String id);
  Future<FailureOr<void>> insert(Tag tag);
  Future<FailureOr<void>> update(Tag tag);
  Future<FailureOr<void>> delete(String id);
}
