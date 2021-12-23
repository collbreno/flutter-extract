import 'package:business/src/core/_core.dart';

abstract class StreamUseCase<T, P> {
  Stream<FailureOr<T>> call(P param);
}

abstract class NoParamStreamUseCase<T> {
  Stream<FailureOr<T>> call();
}

abstract class FutureUseCase<T, P> {
  Future<FailureOr<T>> call(P param);
}

abstract class NoParamFutureUseCase<T> {
  Future<FailureOr<T>> call();
}
