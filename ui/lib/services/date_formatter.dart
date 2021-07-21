import 'package:intl/intl.dart';

final _df = DateFormat('dd/MM/yyyy');

class DateFormatter {
  static String formatShort(DateTime date) {
    return _df.format(date);
  }
}
