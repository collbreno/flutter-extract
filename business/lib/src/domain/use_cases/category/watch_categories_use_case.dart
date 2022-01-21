import 'package:business/business.dart';

class WatchCategoriesUseCase extends NoParamStreamUseCase<List<Category>> {
  final ICategoryRepository repository;

  WatchCategoriesUseCase(this.repository);

  @override
  Stream<FailureOr<List<Category>>> call() async* {
    await Future.delayed(Duration(seconds: 2));
    yield* repository.watchAll();
  }
}
