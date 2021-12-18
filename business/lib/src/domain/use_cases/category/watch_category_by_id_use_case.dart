import 'package:business/business.dart';

class WatchCategoryByIdUseCase extends StreamUseCase<Category, String> {
  final ICategoryRepository repository;

  WatchCategoryByIdUseCase(this.repository);

  @override
  Stream<FailureOr<Category>> call(String id) {
    return repository.watchById(id);
  }
}
