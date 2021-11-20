import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:dartz/dartz.dart';

class SafeDeleteTagWithId extends UseCase<void, String> {
  final ITagRepository repository;

  SafeDeleteTagWithId(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
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
