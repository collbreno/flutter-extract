import 'package:flutter/material.dart';
import 'package:ui/common/form/input_fields/list_tile_input_fields.dart';
import 'package:ui/common/picker_dialog.dart';

class PickerInputField<T> extends StatefulWidget {
  final Iterable<T> items;
  final Widget Function(T) dialogItemBuilder;
  final InputFieldWidget Function(T) inputFieldWidgetBuilder;
  final bool Function(T, String)? onSearch;
  final ValueChanged<T?> onChanged;
  final String? labelText;
  final String? errorText;
  final String hintText;
  final Widget? leading;
  final bool enabled;
  final int columns;
  final T? initialValue;
  final VoidCallback? onTap;

  const PickerInputField({
    Key? key,
    required this.onChanged,
    required this.items,
    required this.dialogItemBuilder,
    required this.inputFieldWidgetBuilder,
    this.initialValue,
    this.onSearch,
    this.labelText,
    this.errorText,
    this.hintText = 'Selecione',
    this.leading,
    this.enabled = true,
    this.columns = 1,
    this.onTap,
  }) : super(key: key);

  @override
  State<PickerInputField<T>> createState() => _PickerInputFieldState<T>();
}

class _PickerInputFieldState<T> extends InputFieldState<T?, PickerInputField<T>> {
  late T? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  void didChange(T? value) {
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OuterListTile(
      errorText: widget.errorText,
      labelText: widget.labelText,
      suffixIcon: Icon(Icons.arrow_drop_down),
      prefixIcon: _value != null ? widget.inputFieldWidgetBuilder(_value!).prefixIcon : null,
      enabled: widget.enabled,
      leading: widget.leading,
      onTap: () async {
        widget.onTap?.call();
        FocusScope.of(context).unfocus();
        final result = await showPickerDialog(
          context: context,
          pickerDialog: PickerDialog.single(
            title: Text('Selecione'),
            columns: widget.columns,
            items: widget.items.toList(),
            renderer: widget.dialogItemBuilder,
            onSearch: widget.onSearch,
          ),
        );
        if (result != null && _value != result.value) {
          didChange(result.value);
          widget.onChanged(result.value);
        }
      },
      child: _value != null ? widget.inputFieldWidgetBuilder(_value!).child : Text(widget.hintText),
    );
  }
}
