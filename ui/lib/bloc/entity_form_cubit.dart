import 'package:built_collection/built_collection.dart';
import 'package:business/business.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:uuid/uuid.dart';

part 'entity_form_state.dart';

abstract class EntityFormCubit<T> extends Cubit<EntityFormState> {
  final FutureUseCase<void, T> insertUseCase;
  final FutureUseCase<void, T> updateUseCase;
  final _uid = Uuid();

  EntityFormCubit({
    required this.insertUseCase,
    required this.updateUseCase,
    required BuiltList<FormzInputSuper> inputs,
    String id = '',
  }) : super(
          EntityFormState(
            id: id,
            status: FormzStatus.pure,
            inputs: inputs,
          ),
        );

  void onFieldChanged(Type type, dynamic value) {
    if (!state.inputs.any((e) => e.runtimeType == type)) {
      throw Exception('${this.runtimeType} does not have a field of type $type');
    }
    final dirty = state.inputs.singleWhere((e) => e.runtimeType == type).dirtyConstructor(value);
    final others = state.inputs.rebuild((e) => e.removeWhere((e) => e.runtimeType == type));
    emit(
      state.copyWith(
        inputs: others.rebuild(
          (e) => e.add(dirty.valid ? dirty : (dirty).pureConstructor(value)),
        ),
        status: Formz.validate(others.rebuild((e) => e.add(dirty)).toList()),
      ),
    );
  }

  void onSubmitted() {
    final all = state.inputs.map((p0) => p0.dirtyConstructor(p0.value));

    emit(state.copyWith(
      inputs: all.toBuiltList(),
      status: Formz.validate(all.toList()),
    ));

    if (state.status.isValid) _submit();
  }

  void _submit() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    late final FutureUseCase<void, T> useCase;

    if (state.id.isEmpty) {
      emit(state.copyWith(id: _uid.v4()));
      useCase = insertUseCase;
    } else {
      useCase = updateUseCase;
    }

    final result = await useCase(mapInputsToEntity(state.id));

    result.fold(
      _onFailed,
      (_) => _onSuccess,
    );
  }

  void _onFailed(Failure error) {
    // TODO: show error
    emit(state.copyWith(status: FormzStatus.submissionFailure));
  }

  void _onSuccess() {
    emit(state.copyWith(status: FormzStatus.submissionSuccess));
    emit(EntityFormState(inputs: getDefaultInputs()));
  }

  T mapInputsToEntity(String id);

  BuiltList<FormzInputSuper> getDefaultInputs();
}

abstract class FormzInputSuper<T, E> extends FormzInput<T, E> {
  const FormzInputSuper.pure(T value) : super.pure(value);

  const FormzInputSuper.dirty(T value) : super.dirty(value);

  FormzInputSuper<T, E> pureConstructor(dynamic value);

  FormzInputSuper<T, E> dirtyConstructor(dynamic value);
}

extension BuiltListFormz<T> on BuiltList<T> {
  E singleWithType<E>() => singleWhere((p0) => p0.runtimeType == E) as E;
}
