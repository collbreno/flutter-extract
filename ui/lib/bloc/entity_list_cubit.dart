import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:business/business.dart';
import 'package:equatable/equatable.dart';

part 'entity_list_state.dart';

class EntityListCubit<T> extends Cubit<EntityListState<T>> {
  final NoParamStreamUseCase<List<T>> _watchAllUseCase;
  late final StreamSubscription<FailureOr<List<T>>> _streamSubscription;

  EntityListCubit({
    required NoParamStreamUseCase<List<T>> watchAllUseCase,
  })  : _watchAllUseCase = watchAllUseCase,
        super(EntityListState.initial()) {
    _startWatching();
  }

  void _startWatching() {
    emit(state.copyWith(items: AsyncData.loading()));

    _streamSubscription = _watchAllUseCase().listen((result) {
      result.fold(
        (error) => emit(state.copyWith(items: AsyncData.withError(error))),
        (items) => emit(state.copyWith(items: AsyncData.withData(items))),
      );
    });
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
