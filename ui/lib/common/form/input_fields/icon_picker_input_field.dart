import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:ui/common/form/input_fields/list_tile_input_fields.dart';
import 'package:ui/common/form/input_fields/picker_input_field.dart';

class IconPickerInputField extends PickerInputField<IconData> {
  IconPickerInputField(
      {Key? key,
      required ValueChanged<IconData?> onChanged,
      IconData? initialValue,
      String? errorText})
      : super(
          key: key,
          onChanged: onChanged,
          items: IconMapper.getAll().toList(),
          initialValue: initialValue,
          errorText: errorText,
          columns: 5,
          onSearch: (icon, text) => IconMapper.getIconName(icon).contains(text),
          leading: Icon(Icons.color_lens),
          dialogItemBuilder: (icon) {
            return Container(
              margin: EdgeInsets.all(8),
              child: Icon(icon),
            );
          },
          inputFieldWidgetBuilder: (icon) {
            return InputFieldWidget(
              child: Text(IconMapper.getIconName(icon)),
              prefixIcon: Icon(icon),
            );
          },
        );
}
