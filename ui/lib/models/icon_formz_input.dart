import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

enum IconFormzInputValidationError { empty, invalid }

class IconFormzInput extends FormzInput<IconData?, IconFormzInputValidationError> {
  const IconFormzInput.pure([IconData? value]) : super.pure(value);

  const IconFormzInput.dirty([IconData? value]) : super.dirty(value);

  @override
  IconFormzInputValidationError? validator(IconData? value) {
    if (value == null) return IconFormzInputValidationError.empty;
    if (!IconMapper.isSupported(value)) return IconFormzInputValidationError.invalid;
    return null;
  }
}
