import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:infrastructure/infrastructure.dart' hide Icons;
import 'package:redux/redux.dart';

class IconConverter {
  final int iconId;

  IconConverter(this.iconId);

  AsyncSnapshot<IconModel> call(Store<AppState> store) {
    final icon = store.state.icons.singleWhere(
      (icon) => icon.id == iconId,
      orElse: () => null,
    );

    if (icon != null) {
      return AsyncSnapshot.withData(ConnectionState.done, convert(icon));
    } else {
      return AsyncSnapshot.waiting();
    }
  }

  IconModel convert(IconEntity iconEntity) {
    if (iconEntity.family == 'MaterialIcons') {
      return IconModel(
        id: iconEntity.id,
        iconData: Icons.adb,
      );
    }
    return null;
  }
}
