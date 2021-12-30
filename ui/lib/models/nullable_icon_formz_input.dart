import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:ui/bloc/entity_form_cubit.dart';

enum NullableIconFormzInputValidationError { invalid }

class NullableIconFormzInput
    extends FormzInputSuper<IconData?, NullableIconFormzInputValidationError> {
  const NullableIconFormzInput.pure([IconData? value]) : super.pure(value);

  const NullableIconFormzInput.dirty([IconData? value]) : super.dirty(value);

  @override
  NullableIconFormzInputValidationError? validator(IconData? value) {
    if (value != null && !IconMapper.isSupported(value))
      return NullableIconFormzInputValidationError.invalid;
    return null;
  }

  @override
  FormzInputSuper<IconData?, NullableIconFormzInputValidationError> dirtyConstructor(value) {
    return NullableIconFormzInput.dirty(value);
  }

  @override
  FormzInputSuper<IconData?, NullableIconFormzInputValidationError> pureConstructor(value) {
    return NullableIconFormzInput.pure(value);
  }
}
