import 'package:equatable/equatable.dart';

class AsyncData<T> extends Equatable {
  final AsyncDataStatus status;
  final T? data;
  final Object? error;

  AsyncData.loading()
      : status = AsyncDataStatus.loading,
        data = null,
        error = null;

  AsyncData.withData(T data)
      : status = AsyncDataStatus.done,
        data = data,
        error = null;

  AsyncData.withError(Object error)
      : status = AsyncDataStatus.done,
        data = null,
        error = error;

  AsyncData.nothing()
      : status = AsyncDataStatus.none,
        data = null,
        error = null;

  bool get hasError => error != null;

  bool get hasData => data != null;

  bool get isLoading => status == AsyncDataStatus.loading;

  @override
  List<Object?> get props => [status, data, error];
}

enum AsyncDataStatus {
  none,
  loading,
  done,
}
