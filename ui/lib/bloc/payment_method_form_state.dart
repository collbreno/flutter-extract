part of 'payment_method_form_cubit.dart';

class PaymentMethodFormState extends Equatable {
  final FormzStatus status;
  final String id;
  final PaymentMethodNameFormzInput name;
  final IconFormzInput icon;
  final ColorFormzInput color;

  const PaymentMethodFormState({
    this.status = FormzStatus.pure,
    this.id = '',
    this.name = const PaymentMethodNameFormzInput.pure(),
    this.icon = const IconFormzInput.pure(),
    this.color = const ColorFormzInput.pure(),
  });

  PaymentMethodFormState.fromPaymentMethod(PaymentMethod paymentMethod)
      : status = FormzStatus.pure,
        id = paymentMethod.id,
        name = PaymentMethodNameFormzInput.pure(paymentMethod.name),
        color = ColorFormzInput.pure(paymentMethod.color),
        icon = IconFormzInput.pure(paymentMethod.icon);

  PaymentMethodFormState copyWith({
    FormzStatus? status,
    String? id,
    PaymentMethodNameFormzInput? name,
    IconFormzInput? icon,
    ColorFormzInput? color,
  }) {
    return PaymentMethodFormState(
      status: status ?? this.status,
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [status, id, name, icon, color];
}
