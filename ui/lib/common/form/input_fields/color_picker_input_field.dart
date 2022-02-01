import 'package:flutter/material.dart';
import 'package:ui/common/form/input_fields/list_tile_input_fields.dart';
import 'package:ui/common/form/input_fields/picker_input_field.dart';
import 'package:ui/services/color_service.dart';

class ColorPickerInputField extends PickerInputField<Color> {
  ColorPickerInputField({
    Key? key,
    required ValueChanged<Color?> onChanged,
    Color? initialValue,
    String? errorText,
  }) : super(
          key: key,
          onChanged: onChanged,
          items: ColorService.colors.keys,
          initialValue: initialValue,
          errorText: errorText,
          columns: 5,
          leading: Icon(Icons.color_lens),
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
}
