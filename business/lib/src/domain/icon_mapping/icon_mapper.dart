import 'package:business/src/domain/icon_mapping/material_icons_map.dart';
import 'package:flutter/material.dart';

class IconMapper {
  IconMapper._();

  static String getIconFamily(IconData icon) {
    return icon.fontFamily!;
  }

  static String getIconName(IconData icon) {
    return MaterialIconsMap.iconMap[icon]!;
  }

  static IconData getIcon({required String name, required String family}) {
    if (family == 'MaterialIcons') {
      return MaterialIconsMap.iconRevserMap[name]!;
    } else {
      throw Exception('Icon Family not supporter');
    }
  }
}
