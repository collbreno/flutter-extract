import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<SinglePickerDialogResult<T>?> showPickerDialog<T>({
  required BuildContext context,
  required PickerDialog<T> pickerDialog,
}) {
  return showDialog(context: context, builder: (ctx) => pickerDialog);
}

Future<Iterable<T>?> showMultiPickerDialog<T>({
  required BuildContext context,
  required PickerDialog<T> pickerDialog,
}) {
  return showDialog(context: context, builder: (ctx) => pickerDialog);
}

class PickerDialog<T> extends StatefulWidget {
  final int columns;
  final bool Function(T, String)? onSearch;
  final bool canRemove;
  final Widget Function(T)? singleRenderer;
  final Widget Function(T, bool)? multipleRenderer;
  final List<T> items;
  final Widget title;
  final Iterable<T>? initialSelection;

  PickerDialog.single({
    required this.title,
    required this.items,
    required Widget Function(T) renderer,
    this.onSearch,
    this.columns = 1,
    this.canRemove = false,
  })  : initialSelection = null,
        singleRenderer = renderer,
        multipleRenderer = null;

  PickerDialog.multiple({
    required this.title,
    required this.items,
    required Widget Function(T, bool) renderer,
    this.onSearch,
    this.columns = 1,
    this.canRemove = false,
    this.initialSelection,
  })  : multipleRenderer = renderer,
        singleRenderer = null;

  @override
  _PickerDialogState<T> createState() => _PickerDialogState<T>();
}

class _PickerDialogState<T> extends State<PickerDialog<T>> {
  final _staticTitleKey = UniqueKey();
  final _textFieldKey = UniqueKey();
  final _searchButtonKey = UniqueKey();
  final _closeButtonKey = UniqueKey();

  late Set<T> _selectedItems;
  late bool _isSearching;
  late List<T> _visibleItems;
  TextEditingController? _controller;
  late FocusNode _focusNode;
  late bool _test;

  bool get _isMultiple => widget.multipleRenderer != null;
  bool get _isSearchable => widget.onSearch != null;

  @override
  void initState() {
    super.initState();
    _selectedItems = Set.from(widget.initialSelection ?? <T>[]);
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
        if (widget.canRemove && !_isMultiple)
          TextButton(
            child: Text('Remove'),
            onPressed: () {
              Navigator.pop(context, SinglePickerDialogResult<T>(null));
            },
          ),
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        if (_isMultiple)
          TextButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.pop(context, _selectedItems);
            },
          ),
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
            duration: const Duration(milliseconds: 200),
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
              final item = _visibleItems[index];
              return InkWell(
                onTap: () {
                  Navigator.pop(context, SinglePickerDialogResult(item));
                },
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: widget.singleRenderer!.call(item),
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
            final item = _visibleItems[index];
            return InkWell(
              onTap: () {
                if (_isMultiple) {
                  setState(() {
                    if (_selectedItems.contains(item)) {
                      _selectedItems.remove(item);
                    } else {
                      _selectedItems.add(item);
                    }
                  });
                } else {
                  Navigator.pop(context, SinglePickerDialogResult(item));
                }
              },
              child: _isMultiple
                  ? widget.multipleRenderer!.call(item, _selectedItems.contains(item))
                  : widget.singleRenderer!.call(item),
            );
          },
        ),
      ),
    );
  }
}

class SinglePickerDialogResult<T> {
  final T? value;

  const SinglePickerDialogResult(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SinglePickerDialogResult && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;
}
