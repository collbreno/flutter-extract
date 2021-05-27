import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:business/src/domain/repositories/subcategory_repository.dart';
import 'package:dartz/dartz.dart';

class InsertSubcategory extends UseCase<void, Subcategory> {
  final ISubcategoryRepository subcategoryRepository;
  final ICategoryRepository categoryRepository;

  InsertSubcategory({
    required this.subcategoryRepository,
    required this.categoryRepository,
  });

  @override
  Future<FailureOr<void>> call(Subcategory subcategory) async {
    final existsParent = await categoryRepository.existsCategoryWithId(subcategory.parent.id);

    return existsParent.fold(
      (failure) => Left(failure),
      (existsParent) {
        if (!existsParent) {
          return Left(EntityDependencyFailure());
        } else {
          return subcategoryRepository.insertSubcategory(subcategory);
        }
      },
    );
  }
}
