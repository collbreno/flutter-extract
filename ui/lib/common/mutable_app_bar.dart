import 'package:flutter/material.dart';

class MutableAppBar<T> extends StatefulWidget implements PreferredSizeWidget {
  final AppBar defaultAppBar;
  final List<Widget> actions;
  final List<T> selectedItems;
  final VoidCallback onClear;

  const MutableAppBar({
    Key? key,
    required this.onClear,
    required this.selectedItems,
    required this.defaultAppBar,
    this.actions = const [],
  }) : super(key: key);

  @override
  _MutableAppBarState<T> createState() => _MutableAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _MutableAppBarState<T> extends State<MutableAppBar> {
  final _appBarKey = UniqueKey();

  bool get isActivated => widget.selectedItems.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 150),
      transitionBuilder: (child, animation) {
        late final Animation<double> myAnimation;
        if (child.key == _appBarKey) {
          if (isActivated) {
            myAnimation = Tween<double>(begin: 0, end: 1).animate(animation);
          } else {
            myAnimation = Tween<double>(begin: 1, end: 0).animate(animation);
          }
        } else {
          myAnimation = Tween<double>(begin: 1, end: 1).animate(animation);
        }

        return SizeTransition(
          sizeFactor: myAnimation,
          axis: Axis.vertical,
          child: child,
        );
      },
      child: isActivated
          ? AppBar(
              title: Text(widget.selectedItems.length.toString()),
              key: _appBarKey,
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: widget.onClear,
              ),
              backgroundColor: Theme.of(context).accentColor,
              actions: widget.actions,
            )
          : widget.defaultAppBar,
    );
  }
}
