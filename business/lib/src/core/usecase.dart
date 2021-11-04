import 'package:business/src/core/_core.dart';

abstract class UseCase<T, P> {
  Future<FailureOr<T>> call(P param);
}

abstract class NoParamUseCase<T> {
  Future<FailureOr<T>> call();
}
