import 'package:bloc/bloc.dart';
import 'package:business/business.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ui/models/_models.dart';
import 'package:uuid/uuid.dart';

part 'payment_method_form_state.dart';

class PaymentMethodFormCubit extends Cubit<PaymentMethodFormState> {
  final _uid = Uuid();
  final FutureUseCase<void, PaymentMethod> _insertPaymentMethod;
  final FutureUseCase<void, PaymentMethod> _updatePaymentMethod;

  PaymentMethodFormCubit({
    required FutureUseCase<void, PaymentMethod> insertPaymentMethod,
    required FutureUseCase<void, PaymentMethod> updatePaymentMethod,
    PaymentMethod? paymentMethod,
  })  : _insertPaymentMethod = insertPaymentMethod,
        _updatePaymentMethod = updatePaymentMethod,
        super(
          paymentMethod == null
              ? PaymentMethodFormState()
              : PaymentMethodFormState.fromPaymentMethod(paymentMethod),
        );
}
