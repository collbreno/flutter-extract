import 'package:moor/moor.dart';

extension BuilderExtension on ColumnBuilder {
  ColumnBuilder references(String text, [bool nullable = false]) =>
      customConstraint('${nullable ? 'NULL' : ''} REFERENCES $text');

  ColumnBuilder unique() => customConstraint('UNIQUE');
}
