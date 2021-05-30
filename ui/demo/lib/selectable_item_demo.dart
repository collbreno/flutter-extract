import 'dart:math';

import 'package:flutter/material.dart';

class SelectableItemDemo extends StatefulWidget {
  const SelectableItemDemo({Key? key}) : super(key: key);

  @override
  _SelectableItemDemoState createState() => _SelectableItemDemoState();
}

class _SelectableItemDemoState extends State<SelectableItemDemo> with TickerProviderStateMixin {
  late bool _isSelected;
  late List<bool> _items;

  @override
  void initState() {
    super.initState();
    _isSelected = true;
    _items = List.generate(20, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selectable Item'),
      ),
      body: GridView.builder(
        itemCount: _items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder: (ctx, index) => SelectableItem(
          isSelected: _items[index],
          onChanged: (value) {
            setState(() {
              _items[index] = value;
            });
          },
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Colors.grey[500],
            elevation: 8,
            child: SizedBox(
              height: 120,
              width: 180,
              child: Center(
                child: Text('Just a demo'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SelectableItem extends StatefulWidget {
  final bool isSelected;
  final ValueChanged<bool> onChanged;
  final Widget child;

  SelectableItem({
    Key? key,
    required this.isSelected,
    required this.onChanged,
    required this.child,
  }) : super(key: key);

  @override
  _SelectableItemState createState() => _SelectableItemState();
}

class _SelectableItemState extends State<SelectableItem> with TickerProviderStateMixin {
  late Animation<double> _rotateAnimation;
  late Animation<double> _scaleAnimation;
  late AnimationController _controller;
  final _checkSize = 32.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 150));

    late TweenSequence<double> tweenSequence;

    if (widget.isSelected) {
      tweenSequence = TweenSequence([
        TweenSequenceItem(
          tween: Tween(begin: 2 * pi, end: 3 * pi / 2),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: Tween(begin: pi / 2, end: 0.0),
          weight: 1,
        ),
      ]);
    } else {
      tweenSequence = TweenSequence([
        TweenSequenceItem(
          tween: Tween(begin: 0.0, end: pi / 2),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: Tween(begin: 3 * pi / 2, end: 2 * pi),
          weight: 1,
        ),
      ]);
    }

    _rotateAnimation = tweenSequence.animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _scaleAnimation = Tween(
      begin: widget.isSelected ? 1.0 : 0.0,
      end: widget.isSelected ? 0.0 : 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 1),
      ),
    );
  }

  Widget _buildCheck() {
    return Positioned(
      right: 0,
      top: 0,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SizedBox(
          height: _checkSize,
          width: _checkSize,
          child: Material(
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_checkSize / 2),
            ),
            color: Colors.transparent,
            elevation: 4,
            child: Container(
              alignment: Alignment.center,
              color: Colors.green,
              child: Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotateAnimation,
      builder: (context, child) => Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(_rotateAnimation.value),
        alignment: FractionalOffset.center,
        child: child,
      ),
      child: GestureDetector(
        onTap: () {
          if (_controller.isAnimating) {
            return;
          } else if (_controller.isDismissed) {
            _controller.forward();
          } else if (_controller.isCompleted) {
            _controller.reverse();
          }
          widget.onChanged(!widget.isSelected);
        },
        child: Stack(
          children: [
            widget.child,
            _buildCheck(),
          ],
        ),
      ),
    );
  }
}
