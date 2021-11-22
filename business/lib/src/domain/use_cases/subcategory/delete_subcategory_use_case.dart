import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/repositories/subcategory_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteSubcategoryUseCase extends UseCase<void, String> {
  final ISubcategoryRepository repository;

  DeleteSubcategoryUseCase(this.repository);

  @override
  Future<FailureOr<void>> call(String id) async {
    final usages = await repository.countUsages(id);
    return usages.fold(
      (failure) => Left(failure),
      (usages) => _handleUsages(id, usages),
    );
  }

  Future<FailureOr<void>> _handleUsages(String id, int usages) async {
    if (usages > 0) {
      return Left(EntityBeingUsedFailure(usages));
    } else {
      return await repository.delete(id);
    }
  }
}
