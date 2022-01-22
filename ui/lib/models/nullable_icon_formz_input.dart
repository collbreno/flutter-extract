import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

enum NullableIconFormzInputValidationError { invalid }

class NullableIconFormzInput extends FormzInput<IconData?, NullableIconFormzInputValidationError> {
  const NullableIconFormzInput.pure([IconData? value]) : super.pure(value);

  const NullableIconFormzInput.dirty([IconData? value]) : super.dirty(value);

  @override
  NullableIconFormzInputValidationError? validator(IconData? value) {
    if (value != null && !IconMapper.isSupported(value))
      return NullableIconFormzInputValidationError.invalid;
    return null;
  }
}
