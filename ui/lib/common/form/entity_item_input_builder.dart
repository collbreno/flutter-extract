import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/bloc/entity_form_cubit.dart';
import 'package:ui/bloc/entity_mutable_list_cubit.dart';
import 'package:ui/common/list_tile_input_fields.dart';
import 'package:ui/models/entity_formz_input.dart';

class EntityItemInputBuilder<E extends Entity, T extends EntityFormCubit> extends StatelessWidget {
  final Key inputKey;
  final Widget Function(E) dialogItemBuilder;
  final InputFieldWidget Function(E) inputFieldWidgetBuilder;

  const EntityItemInputBuilder({
    Key? key,
    required this.inputKey,
    required this.dialogItemBuilder,
    required this.inputFieldWidgetBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntityMutableListCubit<E>, EntityMutableListState<E>>(
      builder: (context, listState) {
        if (listState.items.hasError) {
          return OuterListTile(
            suffixIcon: Icon(Icons.error, color: Theme.of(context).errorColor),
            child: Text('Algo deu errado'),
          );
        } else if (listState.items.hasData) {
          return BlocBuilder<T, EntityFormState>(
            builder: (context, formState) {
              final input = formState.inputs.singleWithType<EntityFormzInput<E>>();

              return PickerInputField<E>(
                key: inputKey,
                onChanged: (value) =>
                    context.read<T>().onFieldChanged<EntityFormzInput<E>, E?>(value),
                items: listState.items.data!,
                dialogItemBuilder: dialogItemBuilder,
                inputFieldWidgetBuilder: inputFieldWidgetBuilder,
                initialValue: input.value,
                errorText: input.invalid ? 'Inválido' : null,
              );
            },
          );
        } else {
          return OuterListTile(
            enabled: false,
            suffixIcon: Container(
              child: Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                    width: 24,
                    height: 24,
                  ),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            child: Text('Loading'),
          );
        }
      },
    );
  }
}
