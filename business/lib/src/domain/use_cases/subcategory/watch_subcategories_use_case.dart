import 'package:business/business.dart';

class WatchSubcategoriesUseCase extends NoParamStreamUseCase<List<Subcategory>> {
  final ISubcategoryRepository repository;

  WatchSubcategoriesUseCase(this.repository);

  @override
  Stream<FailureOr<List<Subcategory>>> call() {
    return repository.watchAll();
  }
}
