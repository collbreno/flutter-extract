import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ui/bloc/entity_form_cubit.dart';
import 'package:ui/common/form/input_fields/list_tile_input_fields.dart';
import 'package:ui/common/form/input_fields/picker_input_field.dart';

class IconInputBuilder<T extends EntityFormCubit, E extends FormzInput<IconData?, Object>>
    extends StatelessWidget {
  final Key inputKey;

  const IconInputBuilder({Key? key, required this.inputKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, EntityFormState>(
      builder: (context, state) {
        final input = state.inputs.singleWithType<E>();
        return PickerInputField<IconData>(
          key: inputKey,
          onChanged: (value) => context.read<T>().onFieldChanged<E, IconData?>(value),
          items: IconMapper.getAll().toList(),
          initialValue: input.value,
          errorText: input.invalid ? "Inválido" : null,
          columns: 5,
          onSearch: (icon, text) => IconMapper.getIconName(icon).contains(text),
          leading: Icon(Icons.color_lens),
          onTap: () => FocusScope.of(context).unfocus(),
          dialogItemBuilder: (icon) {
            return Container(
              child: Icon(icon),
              margin: EdgeInsets.all(8),
            );
          },
          inputFieldWidgetBuilder: (icon) {
            return InputFieldWidget(
              child: Text(IconMapper.getIconName(icon)),
              prefixIcon: Icon(icon),
            );
          },
        );
      },
    );
  }
}
