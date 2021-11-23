import 'package:bloc/bloc.dart';
import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:equatable/equatable.dart';
import 'package:ui/models/_models.dart';
import 'package:ui/models/color_formz_input.dart';
import 'package:uuid/uuid.dart';
import 'package:dartz/dartz.dart';

part 'category_form_state.dart';

class CategoryFormCubit extends Cubit<CategoryFormState> {
  final uid = Uuid();
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
      name: name,
      status: Formz.validate([name, state.color, state.icon]),
    ));
  }

  void onIconChanged(IconData? value) {
    final icon = IconFormzInput.dirty(value);
    emit(state.copyWith(
      icon: icon,
      status: Formz.validate([state.name, state.color, icon]),
    ));
  }

  void onColorChanged(Color? value) {
    final color = ColorFormzInput.dirty(value);
    emit(state.copyWith(
      color: color,
      status: Formz.validate([state.name, color, state.icon]),
    ));
  }

  void onSubmitted() {
    print('on submitted');
    _validate();

    if (state.status.isValid) _submit();
  }

  void _submit() async {
    print('submit');
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    late final Either<Failure, void> result;

    if (state.id.value.isEmpty)
      result = await _insertCategory(Category(
        id: uid.v4(),
        color: state.color.value!,
        icon: state.icon.value!,
        name: state.name.value,
      ));
    else
      result = await _updateCategory(Category(
        id: state.id.value,
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

  void _validate() {
    emit(state.copyWith(status: Formz.validate([state.name, state.color, state.icon])));
  }
}
