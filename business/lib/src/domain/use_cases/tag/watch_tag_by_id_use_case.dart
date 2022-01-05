import 'package:business/business.dart';

class WatchTagByIdUseCase extends StreamUseCase<Tag, String> {
  final ITagRepository repository;

  WatchTagByIdUseCase(this.repository);

  @override
  Stream<FailureOr<Tag>> call(String id) {
    return repository.watchById(id);
  }
}
