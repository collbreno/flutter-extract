import 'package:business/src/core/core.dart';
import 'package:business/src/domain/repositories/subcategory_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteSubcategoryWithId extends UseCase<void, String> {
  final ISubcategoryRepository repository;

  DeleteSubcategoryWithId(this.repository);

  @override
  Future<FailureOr<void>> call(String id) async {
    final usages = await repository.countExpensesWithSubcategoryWithId(id);
    return usages.fold(
      (failure) => Left(failure),
      (usages) => _handleUsages(id, usages),
    );
  }

  Future<FailureOr<void>> _handleUsages(String id, int usages) async {
    if (usages > 0) {
      return Left(EntityBeingUsedFailure(usages));
    } else {
      final deleted = await repository.deleteSubcategoryWithId(id);
      return deleted.fold(
        (failure) => Left(failure),
        (deleted) => _handleDeletedCount(deleted),
      );
    }
  }

  FailureOr<void> _handleDeletedCount(int count) {
    if (count == 0) {
      return Left(NothingToDeleteFailure());
    } else {
      return Right(Null);
    }
  }
}
