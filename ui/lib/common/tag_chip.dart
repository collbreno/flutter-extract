import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TagChip extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color color;

  TagChip.fromTag(Tag tag, {Key? key})
      : title = tag.name,
        icon = tag.icon,
        color = tag.color;

  TagChip.fromStore(Store store, {Key? key})
      : title = store.name,
        icon = Icons.store,
        color = Colors.grey;

  TagChip.fromPaymentMethod(PaymentMethod paymentMethod, {Key? key})
      : title = paymentMethod.name,
        color = paymentMethod.color,
        icon = paymentMethod.icon;

  Color get textColor =>
      ThemeData.estimateBrightnessForColor(color) == Brightness.dark ? Colors.white : Colors.black;

  Widget _buildText() {
    return Text(
      title,
      style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w700),
    );
  }

  Widget _buildIcon() {
    return Icon(
      icon,
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
          color: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
        child: icon == null
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
