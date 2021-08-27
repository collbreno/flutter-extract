import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class AndroidTransition extends PageTransition {
  AndroidTransition(Widget child)
      : super(
          child: child,
          type: PageTransitionType.size,
          alignment: Alignment.bottomCenter,
          duration: Duration(milliseconds: 300),
          reverseDuration: Duration(milliseconds: 300),
          curve: Curves.easeInOutQuart,
        );
}
