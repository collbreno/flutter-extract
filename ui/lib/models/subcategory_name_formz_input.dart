import 'package:infrastructure/infrastructure.dart';
import 'package:ui/bloc/entity_form_cubit.dart';

enum SubcategoryNameFormzInputValidationError {
  empty,
  tooLong,
  tooShort,
}

class SubcategoryNameFormzInput
    extends FormzInputSuper<String, SubcategoryNameFormzInputValidationError> {
  const SubcategoryNameFormzInput.pure([String value = '']) : super.pure(value);

  const SubcategoryNameFormzInput.dirty([String value = '']) : super.dirty(value);

  @override
  SubcategoryNameFormzInputValidationError? validator(String value) {
    if (value.isEmpty) return SubcategoryNameFormzInputValidationError.empty;
    if (value.length < SUBCATEGORY_NAME_MIN)
      return SubcategoryNameFormzInputValidationError.tooShort;
    if (value.length > SUBCATEGORY_NAME_MAX)
      return SubcategoryNameFormzInputValidationError.tooLong;
    return null;
  }

  @override
  FormzInputSuper<String, SubcategoryNameFormzInputValidationError> dirtyConstructor(value) {
    return SubcategoryNameFormzInput.dirty(value);
  }

  @override
  FormzInputSuper<String, SubcategoryNameFormzInputValidationError> pureConstructor(value) {
    return SubcategoryNameFormzInput.pure(value);
  }
}
