import 'package:built_collection/src/list.dart';
import 'package:business/business.dart';
import 'package:ui/bloc/entity_form_cubit.dart';
import 'package:ui/models/_models.dart';

class PaymentMethodFormCubit extends EntityFormCubit<PaymentMethod> {
  PaymentMethodFormCubit({
    required FutureUseCase<void, PaymentMethod> insertUseCase,
    required FutureUseCase<void, PaymentMethod> updateUseCase,
    PaymentMethod? paymentMethod,
  }) : super(
          id: paymentMethod?.id ?? '',
          insertUseCase: insertUseCase,
          updateUseCase: updateUseCase,
          inputs: _getDefaultInputs(paymentMethod),
        );

  static BuiltList<FormzInputSuper> _getDefaultInputs(PaymentMethod? pm) {
    return BuiltList([
      PaymentMethodNameFormzInput.pure(pm?.name ?? ''),
      ColorFormzInput.pure(pm?.color),
      IconFormzInput.pure(pm?.icon),
    ]);
  }

  @override
  BuiltList<FormzInputSuper> getDefaultInputs() {
    return _getDefaultInputs(null);
  }

  @override
  PaymentMethod mapInputsToEntity(String id) {
    return PaymentMethod(
      id: id,
      name: state.inputs.singleWithType<PaymentMethodNameFormzInput>().value,
      color: state.inputs.singleWithType<ColorFormzInput>().value!,
      icon: state.inputs.singleWithType<IconFormzInput>().value!,
    );
  }
}
