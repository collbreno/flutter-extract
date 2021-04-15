import 'package:built_collection/built_collection.dart';
import 'package:business/business.dart';
import 'package:flutter/cupertino.dart';

class FetchIconAction {
  final int iconId;
  final ValueSetter<Exception> onFailed;
  final VoidCallback onSucceeded;

  FetchIconAction(this.iconId, {this.onFailed, this.onSucceeded});
}

class FetchIconSucceededAction {
  final IconModel icon;

  FetchIconSucceededAction(this.icon);
}

class FetchIconsAction {
  final ValueSetter<Exception> onFailed;
  final VoidCallback onSucceeded;

  FetchIconsAction({this.onFailed, this.onSucceeded});
}

class FetchIconsSucceededAction {
  final BuiltList<IconModel> icons;

  FetchIconsSucceededAction(this.icons);
}

class InsertIconAction {
  final IconModel icon;
  final ValueSetter<Exception> onFailed;
  final VoidCallback onSucceeded;

  InsertIconAction(this.icon, {this.onFailed, this.onSucceeded});
}
