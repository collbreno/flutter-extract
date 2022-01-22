import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/bloc/entity_form_cubit.dart';
import 'package:ui/common/list_tile_input_fields.dart';
import 'package:ui/models/_models.dart';
import 'package:ui/services/color_service.dart';

class ColorInputBuilder<T extends EntityFormCubit> extends StatelessWidget {
  final Key inputKey;

  const ColorInputBuilder({Key? key, required this.inputKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, EntityFormState>(
      builder: (context, state) {
        final input = state.inputs.singleWithType<ColorFormzInput>();
        return PickerInputField<Color>(
          key: inputKey,
          onChanged: (value) => context.read<T>().onFieldChanged<ColorFormzInput, Color?>(value),
          items: ColorService.colors.keys,
          initialValue: input.value,
          errorText: input.invalid ? "Inválido" : null,
          columns: 5,
          leading: Icon(Icons.color_lens),
          onTap: () => FocusScope.of(context).unfocus(),
          dialogItemBuilder: (color) {
            return Container(
              decoration: ShapeDecoration(
                shape: CircleBorder(),
                color: color,
              ),
              margin: EdgeInsets.all(8),
            );
          },
          inputFieldWidgetBuilder: (color) {
            return InputFieldWidget(
              child: Text('0x' + color.value.toRadixString(16).toUpperCase()),
              prefixIcon: Icon(
                Icons.circle,
                color: color,
              ),
            );
          },
        );
      },
    );
  }
}
