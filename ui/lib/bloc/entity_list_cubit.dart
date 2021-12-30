import 'package:bloc/bloc.dart';
import 'package:business/business.dart';
import 'package:equatable/equatable.dart';

part 'entity_list_state.dart';

class EntityListCubit<T> extends Cubit<EntityListState<T>> {
  final NoParamStreamUseCase<List<T>> _watchAllUseCase;

  EntityListCubit(this._watchAllUseCase) : super(EntityListInitial()) {
    _startWatching();
  }

  void _startWatching() {
    emit(EntityListLoading());

    _watchAllUseCase().listen((result) {
      result.fold(
        (error) => emit(EntityListError(error)),
        (items) => emit(EntityListFinished(items)),
      );
    });
  }
}
