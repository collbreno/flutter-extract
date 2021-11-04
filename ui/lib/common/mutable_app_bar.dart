import 'package:flutter/material.dart';

class MutableAppBar extends StatefulWidget implements PreferredSizeWidget {
  final AppBar primaryAppBar;
  final AppBar secondaryAppBar;
  final bool isMutated;

  MutableAppBar({
    Key? key,
    required this.primaryAppBar,
    required this.secondaryAppBar,
    required this.isMutated,
  }) : super(key: key);

  @override
  _MutableAppBarState createState() => _MutableAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _MutableAppBarState extends State<MutableAppBar> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).padding.top;
    return IntrinsicHeight(
      child: Stack(
        children: [
          widget.primaryAppBar,
          Center(
            child: AnimatedContainer(
              alignment: Alignment.center,
              duration: Duration(milliseconds: 150),
              height: widget.isMutated ? widget.preferredSize.height + paddingTop : 0,
              child: widget.secondaryAppBar,
            ),
          ),
        ],
      ),
    );
  }
}
