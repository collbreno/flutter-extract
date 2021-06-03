import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TagChip extends StatelessWidget {
  final Tag tag;

  const TagChip({
    Key? key,
    required this.tag,
  }) : super(key: key);

  Color get textColor => ThemeData.estimateBrightnessForColor(tag.color) == Brightness.dark
      ? Colors.black
      : Colors.white;

  Widget _buildText() {
    return Text(
      tag.name,
      style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w700),
    );
  }

  Widget _buildIcon() {
    return Icon(
      tag.icon,
      color: textColor,
      size: 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container(
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: tag.color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
        child: tag.icon == null
            ? _buildText()
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildIcon(),
                  SizedBox(width: 2),
                  _buildText(),
                ],
              ),
      ),
    );
  }
}
