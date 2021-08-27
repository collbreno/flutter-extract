import 'package:business/business.dart';
import 'package:flutter/material.dart';

class ExpenseListItem extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onTap;

  const ExpenseListItem({
    Key? key,
    required this.expense,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              expense.subcategory.icon,
              color: expense.subcategory.color,
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Icon(
                  expense.subcategory.parent.icon,
                  size: 16,
                  color: expense.subcategory.parent.color,
                ),
              ),
            ),
          ],
        ),
      ),
      title: Text(expense.subcategory.name),
      subtitle: Text(expense.description),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            MoneyService.format(expense.value),
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                expense.tags.length.toString(),
                style: TextStyle(fontSize: 12),
              ),
              Icon(
                Icons.label,
                size: 14,
              ),
              SizedBox(width: 6),
              Text(
                2.toString(),
                style: TextStyle(fontSize: 12),
              ),
              Icon(
                Icons.attach_file,
                size: 14,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
