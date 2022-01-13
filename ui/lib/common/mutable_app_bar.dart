import 'package:flutter/material.dart';

enum AppBarMutationDirection {
  vertical,
  horizontal,
  both,
}

class MutableAppBar extends StatefulWidget implements PreferredSizeWidget {
  final PreferredSizeWidget primaryAppBar;
  final PreferredSizeWidget secondaryAppBar;
  final bool isMutated;
  final VoidCallback onBackPressed;
  final AppBarMutationDirection mutationDirection;
  final Alignment alignment;
  final Decoration Function(bool)? decorationBuilder;

  MutableAppBar({
    Key? key,
    required this.primaryAppBar,
    required this.secondaryAppBar,
    required this.isMutated,
    required this.onBackPressed,
    this.decorationBuilder,
    this.mutationDirection = AppBarMutationDirection.vertical,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  _MutableAppBarState createState() => _MutableAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _MutableAppBarState extends State<MutableAppBar> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final appBarWidth = mediaQuery.size.width;
    final appBarHeight = mediaQuery.padding.top + widget.preferredSize.height;

    return WillPopScope(
      onWillPop: () async {
        if (widget.isMutated) {
          widget.onBackPressed();
          return false;
        }
        return true;
      },
      child: IntrinsicHeight(
        child: Stack(
          children: [
            widget.primaryAppBar,
            Align(
              alignment: widget.alignment,
              child: AnimatedContainer(
                decoration: widget.decorationBuilder?.call(widget.isMutated),
                clipBehavior: widget.decorationBuilder != null ? Clip.antiAlias : Clip.none,
                duration: Duration(milliseconds: 150),
                width: widget.mutationDirection == AppBarMutationDirection.vertical
                    ? appBarWidth
                    : widget.isMutated
                        ? appBarWidth
                        : 0,
                height: widget.mutationDirection == AppBarMutationDirection.horizontal
                    ? appBarHeight
                    : widget.isMutated
                        ? appBarHeight
                        : 0,
                child: widget.secondaryAppBar,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
