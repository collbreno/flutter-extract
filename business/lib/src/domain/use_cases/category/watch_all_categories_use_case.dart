import 'package:business/business.dart';

class WatchAllCategoriesUseCase extends NoParamStreamUseCase<List<Category>> {
  final ICategoryRepository repository;

  WatchAllCategoriesUseCase(this.repository);

  @override
  Stream<FailureOr<List<Category>>> call() {
    return repository.watchAll();
  }
}
