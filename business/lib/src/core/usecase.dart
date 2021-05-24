import 'package:business/src/core/_core.dart';
import 'package:equatable/equatable.dart';

abstract class UseCase<T, P> {
  Future<FailureOr<T>> call(P param);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
