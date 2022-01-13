import 'package:flutter/material.dart';
import 'package:ui/common/mutable_app_bar.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final ValueChanged<String> onChanged;
  final Widget? title;

  const SearchAppBar({
    Key? key,
    required this.onChanged,
    this.title,
  }) : super(key: key);

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _SearchAppBarState extends State<SearchAppBar> {
  late bool _isSearching;
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late bool _showClearButton;

  @override
  void initState() {
    super.initState();
    _isSearching = false;
    _focusNode = FocusNode();
    _showClearButton = false;
    _controller = TextEditingController()
      ..addListener(() {
        widget.onChanged(_controller.text);
        setState(() {
          _showClearButton = _controller.text.isNotEmpty;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return MutableAppBar(
      alignment: Alignment.centerRight,
      mutationDirection: AppBarMutationDirection.horizontal,
      decorationBuilder: (isMutated) => ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isMutated ? 0 : 24),
            bottomLeft: Radius.circular(isMutated ? 0 : 24),
          ),
        ),
      ),
      primaryAppBar: AppBar(
        title: widget.title,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = true;
                _focusNode.requestFocus();
              });
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      isMutated: _isSearching,
      onBackPressed: () {
        setState(() {
          _focusNode.unfocus();
          _controller.clear();
          _isSearching = false;
        });
      },
      secondaryAppBar: AppBar(
        actions: [
          if (_showClearButton)
            IconButton(
              color: Theme.of(context).colorScheme.onSurface,
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _controller.clear();
                  _focusNode.requestFocus();
                });
              },
            ),
        ],
        leading: IconButton(
          color: Theme.of(context).colorScheme.onSurface,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _controller.clear();
              _focusNode.unfocus();
              _isSearching = false;
            });
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: TextField(
          focusNode: _focusNode,
          controller: _controller,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
