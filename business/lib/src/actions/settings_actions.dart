import 'package:flutter/cupertino.dart';

class ToggleBrightnessAction {}

class SetBrightnessAction {
  final Brightness brightness;

  SetBrightnessAction(this.brightness);
}
