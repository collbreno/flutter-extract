import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PickerDialog<T> extends StatefulWidget {
  final EdgeInsets contentPadding;
  final int columns;
  final bool Function(T, String)? onSearch;
  final ValueSetter<T> onItemSelected;
  final VoidCallback? onRemove;
  final Widget Function(T) renderer;
  final List<T> items;
  final Widget title;

  PickerDialog({
    required this.title,
    required this.items,
    required this.renderer,
    required this.onItemSelected,
    this.onSearch,
    this.contentPadding = const EdgeInsets.all(12),
    this.columns = 1,
    this.onRemove,
  });
  @override
  _PickerDialogState<T> createState() => _PickerDialogState<T>();
}

class _PickerDialogState<T> extends State<PickerDialog<T>> {
  final _staticTitleKey = UniqueKey();
  final _textFieldKey = UniqueKey();
  final _searchButtonKey = UniqueKey();
  final _closeButtonKey = UniqueKey();

  late bool _isSearching;
  late List<T> _visibleItems;
  TextEditingController? _controller;
  late FocusNode _focusNode;
  late bool _test;

  bool get _isSearchable => widget.onSearch != null;

  @override
  void initState() {
    super.initState();
    _isSearching = false;
    _visibleItems = widget.items;
    _test = false;

    _focusNode = FocusNode()
      ..addListener(() {
        setState(() {
          _test = _focusNode.hasFocus;
        });
      });
    if (widget.onSearch != null) {
      _controller = TextEditingController()
        ..addListener(() {
          setState(() {
            _visibleItems = widget.items
                .where((element) => widget.onSearch!(element, _controller!.text))
                .toList();
          });
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 0),
      title: _renderTitle(),
      content: _renderItems(),
      actions: [
        if (widget.onRemove != null)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onRemove!();
            },
            child: Text('Remove'),
          ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        )
      ],
    );
  }

  Widget _renderTitle() {
    if (_isSearchable) {
      return _renderSearchableTitle();
    }
    return _renderStaticTitle();
  }

  Widget _renderStaticTitle() {
    return Container(
      key: _staticTitleKey,
      child: widget.title,
    );
  }

  Widget _renderSearchableTitle() {
    return Stack(
      fit: StackFit.loose,
      children: <Widget>[
        _isSearching ? _renderTextField() : _renderStaticTitle(),
        Positioned(
          top: -12,
          right: -12,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isSearching ? _renderCloseButton() : _renderSearchButton(),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
          ),
        )
      ],
    );
  }

  Widget _renderTextField() {
    return TextField(
      key: _textFieldKey,
      autofocus: true,
      controller: _controller!,
      focusNode: _focusNode,
      decoration: InputDecoration(
        isCollapsed: true,
        hintText: "Pesquisar",
        border: InputBorder.none,
      ),
    );
  }

  Widget _renderCloseButton() {
    return IconButton(
      key: _closeButtonKey,
      onPressed: () {
        setState(() {
          _controller!.clear();
          _isSearching = false;
        });
      },
      icon: Icon(Icons.close),
    );
  }

  Widget _renderSearchButton() {
    return IconButton(
      key: _searchButtonKey,
      onPressed: () {
        setState(() => _isSearching = true);
      },
      icon: Icon(Icons.search),
    );
  }

  Widget _renderItems() {
    if (widget.columns > 1) {
      return Container(
        height: 300,
        width: double.maxFinite,
        child: Scrollbar(
          child: GridView.builder(
            itemCount: _visibleItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.columns,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  widget.onItemSelected(_visibleItems[index]);
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: widget.renderer(_visibleItems[index]),
                ),
              );
            },
          ),
        ),
      );
    }
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      height: _test && _isSearching ? 200 : 300,
      width: double.maxFinite,
      child: Scrollbar(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _visibleItems.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                widget.onItemSelected(_visibleItems[index]);
                Navigator.pop(context);
              },
              child: widget.renderer(_visibleItems[index]),
            );
          },
        ),
      ),
    );
  }
}
