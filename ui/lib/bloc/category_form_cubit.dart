import 'package:bloc/bloc.dart';
import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:equatable/equatable.dart';
import 'package:ui/models/_models.dart';
import 'package:ui/models/color_formz_input.dart';
import 'package:ui/screens/category_list/bloc/category_list_cubit.dart';
import 'package:ui/screens/category_view/bloc/category_view_cubit.dart';
import 'package:uuid/uuid.dart';
import 'package:dartz/dartz.dart';

part 'category_form_state.dart';

class CategoryFormCubit extends Cubit<CategoryFormState> {
  final _uid = Uuid();
  final UseCase<void, Category> _insertCategory;
  final UseCase<void, Category> _updateCategory;
  CategoryFormCubit({
    required UseCase<void, Category> insertCategory,
    required UseCase<void, Category> updateCategory,
    Category? category,
  })  : _insertCategory = insertCategory,
        _updateCategory = updateCategory,
        super(category == null ? CategoryFormState() : CategoryFormState.fromCategory(category));

  void onNameChanged(String value) {
    final name = CategoryNameFormzInput.dirty(value);
    emit(state.copyWith(
      name: name.valid ? name : CategoryNameFormzInput.pure(value),
      status: Formz.validate([name, state.color, state.icon]),
    ));
  }

  void onIconChanged(IconData? value) {
    final icon = IconFormzInput.dirty(value);
    emit(state.copyWith(
      icon: icon.valid ? icon : IconFormzInput.pure(value),
      status: Formz.validate([state.name, state.color, icon]),
    ));
  }

  void onColorChanged(Color? value) {
    final color = ColorFormzInput.dirty(value);
    emit(state.copyWith(
      color: color.valid ? color : ColorFormzInput.pure(value),
      status: Formz.validate([state.name, color, state.icon]),
    ));
  }

  void onSubmitted() {
    final name = CategoryNameFormzInput.dirty(state.name.value);
    final color = ColorFormzInput.dirty(state.color.value);
    final icon = IconFormzInput.dirty(state.icon.value);

    emit(state.copyWith(
      name: name,
      color: color,
      icon: icon,
      status: Formz.validate([name, color, icon]),
    ));

    if (state.status.isValid) _submit();
  }

  void _submit() async {
    print('submit');
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    late final UseCase<void, Category> useCase;

    if (state.id.isEmpty) {
      emit(state.copyWith(id: _uid.v4()));
      useCase = _insertCategory;
    } else {
      useCase = _updateCategory;
    }
    final result = await useCase(Category(
      id: state.id,
      color: state.color.value!,
      icon: state.icon.value!,
      name: state.name.value,
    ));

    result.fold(
      _onFailed,
      _onSuccess,
    );
  }

  void _onFailed(Failure error) {
    // TODO: show error
    emit(state.copyWith(status: FormzStatus.submissionFailure));
  }

  void _onSuccess(void _) {
    emit(state.copyWith(status: FormzStatus.submissionSuccess));
    emit(CategoryFormState());
  }
}
