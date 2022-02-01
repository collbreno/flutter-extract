import 'package:flutter/material.dart';

const outerListTileHorizontalTitleGap = 8.0;

class InputFieldWidget {
  final Widget? prefixIcon;
  final Widget child;

  InputFieldWidget({required this.child, this.prefixIcon});
}

abstract class InputFieldState<T, E extends StatefulWidget> extends State<E> {
  void didChange(T value);
}

class OuterListTile extends StatelessWidget {
  final Widget? leading;
  final bool enabled;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget child;
  final VoidCallback? onClear;
  final String? errorText;
  final String? labelText;

  OuterListTile({
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
      horizontalTitleGap: outerListTileHorizontalTitleGap,
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
