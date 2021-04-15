import 'package:business/business.dart';
import 'package:business/src/converters/icon_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

void main() {
  final converter = IconConverter(2);

  StoreConnector<AppState, AsyncSnapshot<IconModel>>(
    builder: (BuildContext context, vm) => Container(),
    converter: converter,
  );
}
