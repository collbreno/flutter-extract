import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ui/bloc/entity_form_cubit.dart';
import 'package:ui/common/form/input_fields/text_input_field.dart';

class TextInputBuilder<T extends EntityFormCubit, E extends FormzInput<String, Object>>
    extends StatelessWidget {
  final Key inputKey;

  const TextInputBuilder({
    Key? key,
    required this.inputKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, EntityFormState>(
      builder: (context, state) {
        final input = state.inputs.singleWithType<E>();
        return TextInputField(
          key: inputKey,
          onChanged: (value) => context.read<T>().onFieldChanged<E, String>(value),
          initialValue: input.value,
          leading: Icon(Icons.edit),
          hintText: "Insira o nome",
          errorText: input.invalid ? "Inválido" : null,
        );
      },
    );
  }
}
