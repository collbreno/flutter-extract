import 'package:flutter/material.dart';

class SearchableAppBar extends StatefulWidget implements PreferredSizeWidget {
  final ValueChanged<String> onChanged;
  final Widget? title;

  const SearchableAppBar({
    Key? key,
    required this.onChanged,
    this.title,
  }) : super(key: key);

  @override
  State<SearchableAppBar> createState() => _SearchableAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _SearchableAppBarState extends State<SearchableAppBar> {
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
    return WillPopScope(
      onWillPop: () async {
        if (_isSearching) {
          setState(() {
            _isSearching = false;
            _controller.clear();
          });
          return false;
        }
        return true;
      },
      child: Stack(
        children: [
          AppBar(
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
          Align(
            alignment: Alignment.centerRight,
            child: AnimatedContainer(
              alignment: Alignment.center,
              duration: Duration(milliseconds: 150),
              width: _isSearching ? mediaQuery.size.width : 0,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_isSearching ? 0 : 48),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: AppBar(
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
            ),
          ),
        ],
      ),
    );
  }
}
