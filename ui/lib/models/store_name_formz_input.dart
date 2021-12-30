import 'package:infrastructure/infrastructure.dart';
import 'package:ui/bloc/entity_form_cubit.dart';

enum StoreNameFormzInputValidationError {
  empty,
  tooLong,
  tooShort,
}

class StoreNameFormzInput extends FormzInputSuper<String, StoreNameFormzInputValidationError> {
  const StoreNameFormzInput.pure([String value = '']) : super.pure(value);

  const StoreNameFormzInput.dirty([String value = '']) : super.dirty(value);

  @override
  StoreNameFormzInputValidationError? validator(String value) {
    if (value.isEmpty) return StoreNameFormzInputValidationError.empty;
    if (value.length < STORE_NAME_MIN) return StoreNameFormzInputValidationError.tooShort;
    if (value.length > STORE_NAME_MAX) return StoreNameFormzInputValidationError.tooLong;
    return null;
  }

  @override
  FormzInputSuper<String, StoreNameFormzInputValidationError> dirtyConstructor(value) {
    return StoreNameFormzInput.dirty(value);
  }

  @override
  FormzInputSuper<String, StoreNameFormzInputValidationError> pureConstructor(value) {
    return StoreNameFormzInput.pure(value);
  }
}
