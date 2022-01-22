import 'package:formz/formz.dart';
import 'package:infrastructure/infrastructure.dart';

enum TagNameFormzInputValidationError {
  empty,
  tooLong,
  tooShort,
}

class TagNameFormzInput extends FormzInput<String, TagNameFormzInputValidationError> {
  const TagNameFormzInput.pure([String value = '']) : super.pure(value);

  const TagNameFormzInput.dirty([String value = '']) : super.dirty(value);

  @override
  TagNameFormzInputValidationError? validator(String value) {
    if (value.isEmpty) return TagNameFormzInputValidationError.empty;
    if (value.length < TAG_NAME_MIN) return TagNameFormzInputValidationError.tooShort;
    if (value.length > TAG_NAME_MAX) return TagNameFormzInputValidationError.tooLong;
    return null;
  }
}
