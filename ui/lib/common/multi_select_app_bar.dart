import 'package:flutter/material.dart';
import 'package:ui/common/mutable_app_bar.dart';

class MultiSelectAppBar<T> extends MutableAppBar {
  MultiSelectAppBar({
    Key? key,
    required PreferredSizeWidget defaultAppBar,
    required VoidCallback onClear,
    required Iterable<T> selectedItems,
    List<Widget> actions = const [],
    Color? backgroundColorWhenSelected,
    Icon clearIcon = const Icon(Icons.clear),
  }) : super(
          key: key,
          isMutated: selectedItems.isNotEmpty,
          primaryAppBar: defaultAppBar,
          secondaryAppBar: AppBar(
            title: Text(selectedItems.length.toString()),
            leading: IconButton(
              icon: clearIcon,
              onPressed: onClear,
            ),
            actions: actions,
            backgroundColor: backgroundColorWhenSelected,
          ),
        );
}
