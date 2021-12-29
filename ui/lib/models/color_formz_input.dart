import 'package:flutter/material.dart';
import 'package:ui/bloc/entity_form_cubit.dart';

enum ColorFormzInputValidationError { empty }

class ColorFormzInput extends FormzInputSuper<Color?, ColorFormzInputValidationError> {
  const ColorFormzInput.pure([Color? value]) : super.pure(value);

  const ColorFormzInput.dirty([Color? value]) : super.dirty(value);

  @override
  ColorFormzInputValidationError? validator(Color? value) {
    if (value == null) return ColorFormzInputValidationError.empty;
    return null;
  }

  @override
  FormzInputSuper<Color?, ColorFormzInputValidationError> dirtyConstructor(value) {
    return ColorFormzInput.dirty(value);
  }

  @override
  FormzInputSuper<Color?, ColorFormzInputValidationError> pureConstructor(value) {
    return ColorFormzInput.pure(value);
  }
}
