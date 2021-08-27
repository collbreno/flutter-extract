class MoneyService {
  static final delimiter = ',';
  static final symbol = 'R\$';

  static String format(int value) {
    var str = value.toString();
    while (str.length < 3) {
      str = '0' + str;
    }
    final limit = str.length - 2;
    return '$symbol ${str.substring(0, limit)}$delimiter${str.substring(limit)}';
  }
}
