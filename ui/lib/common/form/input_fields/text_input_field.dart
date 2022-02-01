import 'package:flutter/material.dart';
import 'package:ui/common/form/input_fields/list_tile_input_fields.dart';

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
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends InputFieldState<String, TextInputField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
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
      horizontalTitleGap: outerListTileHorizontalTitleGap,
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
