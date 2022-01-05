import 'package:business/business.dart';

class WatchTagsUseCase extends NoParamStreamUseCase<List<Tag>> {
  final ITagRepository repository;

  WatchTagsUseCase(this.repository);

  @override
  Stream<FailureOr<List<Tag>>> call() {
    return repository.watchAll();
  }
}
