import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

enum ColorFormzInputValidationError { empty }

class ColorFormzInput extends FormzInput<Color?, ColorFormzInputValidationError> {
  const ColorFormzInput.pure([Color? value]) : super.pure(null);

  const ColorFormzInput.dirty([Color? value]) : super.dirty(value);

  @override
  ColorFormzInputValidationError? validator(Color? value) {
    if (value == null) return ColorFormzInputValidationError.empty;
    return null;
  }
}
