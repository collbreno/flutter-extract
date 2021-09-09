import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:test/test.dart';

Matcher orderedRightEquals(List expected) => _OrderedRightEquals(expected);

class _OrderedRightEquals extends Matcher {
  final List _expected;

  _OrderedRightEquals(this._expected);

  @override
  bool matches(dynamic item, Map matchState) {
    return item is Right<dynamic, List> &&
        listEquals(
          item.getOrElse(() => throw Exception()),
          _expected,
        );
  }

  @override
  Description describe(Description description) =>
      description.add('Right list equals ').addDescriptionOf(_expected);
}
