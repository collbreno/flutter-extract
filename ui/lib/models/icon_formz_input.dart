import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:ui/bloc/entity_form_cubit.dart';

enum IconFormzInputValidationError { empty, invalid }

class IconFormzInput extends FormzInputSuper<IconData?, IconFormzInputValidationError> {
  const IconFormzInput.pure([IconData? value]) : super.pure(value);

  const IconFormzInput.dirty([IconData? value]) : super.dirty(value);

  @override
  IconFormzInputValidationError? validator(IconData? value) {
    if (value == null) return IconFormzInputValidationError.empty;
    if (!IconMapper.isSupported(value)) return IconFormzInputValidationError.invalid;
    return null;
  }

  @override
  FormzInputSuper<IconData?, IconFormzInputValidationError> dirtyConstructor(value) {
    return IconFormzInput.dirty(value);
  }

  @override
  FormzInputSuper<IconData?, IconFormzInputValidationError> pureConstructor(value) {
    return IconFormzInput.pure(value);
  }
}
