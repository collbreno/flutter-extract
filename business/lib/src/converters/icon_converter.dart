import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class IconConverter {
  final int iconId;

  IconConverter(this.iconId);

  AsyncSnapshot<IconModel> call(Store<AppState> store) {
    if (store.state.icons.any((icon) => icon.id == iconId)) {
      final icon = store.state.icons.singleWhere((icon) => icon.id == iconId);
      return AsyncSnapshot.withData(ConnectionState.done, icon);
    } else {
      return AsyncSnapshot.nothing();
    }
  }
}
