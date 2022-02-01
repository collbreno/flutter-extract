import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ui/bloc/entity_form_cubit.dart';
import 'package:ui/common/form/input_fields/icon_picker_input_field.dart';

class IconInputBuilder<T extends EntityFormCubit, E extends FormzInput<IconData?, Object>>
    extends StatelessWidget {
  final Key inputKey;

  const IconInputBuilder({Key? key, required this.inputKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, EntityFormState>(
      builder: (context, state) {
        final input = state.inputs.singleWithType<E>();
        return IconPickerInputField(
          key: inputKey,
          onChanged: (value) => context.read<T>().onFieldChanged<E, IconData?>(value),
          initialValue: input.value,
          errorText: input.invalid ? 'Inválido' : null,
        );
      },
    );
  }
}
