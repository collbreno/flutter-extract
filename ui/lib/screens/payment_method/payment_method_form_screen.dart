import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/bloc/payment_method_form_cubit.dart';
import 'package:ui/common/form/entity_form_builder.dart';
import 'package:ui/navigation/page_transitions.dart';
import 'package:ui/navigation/screen.dart';
import 'package:uuid/uuid.dart';

class PaymentMethodFormScreen extends StatelessWidget implements Screen {
  final PaymentMethod? paymentMethod;

  const PaymentMethodFormScreen._({Key? key, this.paymentMethod}) : super(key: key);

  static Route route([PaymentMethod? paymentMethod]) {
    return AndroidTransition(PaymentMethodFormScreen._(paymentMethod: paymentMethod));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentMethodFormCubit(
        insertUseCase: context.read<InsertPaymentMethodUseCase>(),
        updateUseCase: context.read<UpdatePaymentMethodUseCase>(),
        paymentMethod: paymentMethod,
        uid: Uuid(),
      ),
      child: EntityFormBuilder<PaymentMethodFormCubit>(
        onOpenEntity: (value) {},
        titleWhenCreating: 'Criar Método de Pgto',
        titleWhenEditing: 'Editar Método de Pgto',
      ),
    );
  }
}
