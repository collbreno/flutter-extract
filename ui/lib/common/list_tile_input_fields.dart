import 'package:flutter/material.dart';
import 'package:ui/common/picker_dialog.dart';

const _horizontalTitleGap = 8.0;

class InputFieldWidget {
  final Widget? prefixIcon;
  final Widget child;

  InputFieldWidget({required this.child, this.prefixIcon});
}

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
  State<PickerInputField<T>> createState() => PickerInputFieldState<T>();
}

class PickerInputFieldState<T> extends State<PickerInputField<T>> {
  late T? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void didChange(T? value) {
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _OuterListTile(
      errorText: widget.errorText,
      labelText: widget.labelText,
      suffixIcon: Icon(Icons.arrow_drop_down),
      prefixIcon: _value != null ? widget.inputFieldWidgetBuilder(_value!).prefixIcon : null,
      child: _value != null
          ? widget.inputFieldWidgetBuilder(_value!).child
          : Text(widget.hintText),
      enabled: widget.enabled,
      leading: widget.leading,
      onTap: () async {
        widget.onTap?.call();
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
    );
  }
}

class TextInputField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final int? minLines;
  final int? maxLines;
  final Widget? leading;
  final FocusNode? focusNode;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final String? initialValue;
  final bool enabled;

  const TextInputField({
    Key? key,
    required this.onChanged,
    this.initialValue,
    this.minLines,
    this.maxLines = 1,
    this.leading,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.errorText,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<TextInputField> createState() => TextInputFieldState();
}

class TextInputFieldState extends State<TextInputField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  void didChange(String value) {
    setState(() {
      _controller.text = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: widget.leading,
      enabled: widget.enabled,
      horizontalTitleGap: _horizontalTitleGap,
      title: TextField(
        onChanged: widget.onChanged,
        focusNode: widget.focusNode,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        controller: _controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: widget.hintText,
          errorText: widget.errorText,
          labelText: widget.labelText,
        ),
      ),
    );
  }
}

class _OuterListTile extends StatelessWidget {
  final Widget? leading;
  final bool enabled;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget child;
  final VoidCallback? onClear;
  final String? errorText;
  final String? labelText;

  _OuterListTile({
    Key? key,
    this.leading,
    this.enabled = true,
    this.onTap,
    this.suffixIcon,
    this.prefixIcon,
    this.onClear,
    this.errorText,
    this.labelText,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: enabled,
      horizontalTitleGap: _horizontalTitleGap,
      leading: leading,
      trailing: errorText != null
          ? Icon(
              Icons.error,
              color: Theme.of(context).errorColor,
            )
          : onClear != null
              ? IconButton(onPressed: onClear, icon: Icon(Icons.close))
              : null,
      title: InkWell(
        onTap: enabled ? onTap : null,
        child: InputDecorator(
          child: child,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: labelText,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            errorText: errorText,
          ),
        ),
      ),
    );
  }
}
