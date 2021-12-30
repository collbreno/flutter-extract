import 'package:infrastructure/infrastructure.dart';
import 'package:ui/bloc/entity_form_cubit.dart';

enum PaymentMethodNameFormzInputValidationError {
  empty,
  tooLong,
  tooShort,
}

class PaymentMethodNameFormzInput
    extends FormzInputSuper<String, PaymentMethodNameFormzInputValidationError> {
  const PaymentMethodNameFormzInput.pure([String value = '']) : super.pure(value);

  const PaymentMethodNameFormzInput.dirty([String value = '']) : super.dirty(value);

  @override
  PaymentMethodNameFormzInputValidationError? validator(String value) {
    if (value.isEmpty) return PaymentMethodNameFormzInputValidationError.empty;
    if (value.length < PAYMENT_METHOD_NAME_MIN)
      return PaymentMethodNameFormzInputValidationError.tooShort;
    if (value.length > PAYMENT_METHOD_NAME_MAX)
      return PaymentMethodNameFormzInputValidationError.tooLong;
    return null;
  }

  @override
  FormzInputSuper<String, PaymentMethodNameFormzInputValidationError> dirtyConstructor(value) {
    return PaymentMethodNameFormzInput.dirty(value);
  }

  @override
  FormzInputSuper<String, PaymentMethodNameFormzInputValidationError> pureConstructor(value) {
    return PaymentMethodNameFormzInput.pure(value);
  }
}
