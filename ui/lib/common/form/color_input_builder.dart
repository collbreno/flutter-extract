import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/bloc/entity_form_cubit.dart';
import 'package:ui/common/form/input_fields/color_picker_input_field.dart';
import 'package:ui/models/_models.dart';

class ColorInputBuilder<T extends EntityFormCubit> extends StatelessWidget {
  final Key inputKey;

  const ColorInputBuilder({Key? key, required this.inputKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, EntityFormState>(
      builder: (context, state) {
        final input = state.inputs.singleWithType<ColorFormzInput>();
        return ColorPickerInputField(
          key: inputKey,
          onChanged: (value) => context.read<T>().onFieldChanged<ColorFormzInput, Color?>(value),
          initialValue: input.value,
          errorText: input.invalid ? 'Inválido' : null,
        );
      },
    );
  }
}
