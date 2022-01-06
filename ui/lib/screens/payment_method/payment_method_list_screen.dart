import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/bloc/entity_list_cubit.dart';
import 'package:ui/common/entity_list_builder.dart';
import 'package:ui/navigation/page_transitions.dart';
import 'package:ui/screens/payment_method/payment_method_form_screen.dart';

class PaymentMethodListScreen extends StatelessWidget {
  const PaymentMethodListScreen._({Key? key}) : super(key: key);

  static Route route() {
    return AndroidTransition(PaymentMethodListScreen._());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EntityListCubit<PaymentMethod>(
        watchAllUseCase: context.read<WatchPaymentMethodsUseCase>(),
        editItemCallback: (item) => Navigator.of(context).push(PaymentMethodFormScreen.route(item)),
        openItemCallback: (item) {
          // TODO: implement
          print('open item');
        },
      ),
      child: EntityListBuilder<PaymentMethod>(
        appBarTitle: 'Métodos de Pagamento',
        onAddPressed: () => Navigator.of(context).push(PaymentMethodFormScreen.route()),
        itemBuilder: (context, item, selected) {
          return ListTile(
            title: Text(item.name),
            leading: Icon(item.icon, color: item.color),
            selected: selected,
            trailing: AnimatedScale(
              duration: Duration(milliseconds: 100),
              scale: selected ? 1 : 0,
              child: Icon(
                Icons.check,
                key: ValueKey(item.id),
              ),
            ),
          );
        },
      ),
    );
  }
}
