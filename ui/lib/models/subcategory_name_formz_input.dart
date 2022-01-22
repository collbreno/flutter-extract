import 'package:formz/formz.dart';
import 'package:infrastructure/infrastructure.dart';

enum SubcategoryNameFormzInputValidationError {
  empty,
  tooLong,
  tooShort,
}

class SubcategoryNameFormzInput
    extends FormzInput<String, SubcategoryNameFormzInputValidationError> {
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
}
