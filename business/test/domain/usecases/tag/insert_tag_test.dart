import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:business/src/domain/usecases/tag/_tag.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:business/fixtures.dart';

import '_mock.mocks.dart';

void main() {
  final fix = FixtureTag();
  late ITagRepository repository;
  late InsertTag useCase;

  setUp(() {
    repository = MockITagRepository();
    useCase = InsertTag(repository);
  });

  test('should insert the tag on repository', () async {
    final tag = fix.tag1;

    when(repository.insertTag(tag)).thenAnswer((_) async => Right(Null));

    final result = await useCase(tag);

    expect(result, Right(Null));

    verify(repository.insertTag(tag));
    verifyNoMoreInteractions(repository);
  });

  test('should return $UnknownDatabaseFailure when repository fails', () async {
    final failure = UnknownDatabaseFailure();
    final tag = fix.tag1;

    when(repository.insertTag(tag)).thenAnswer((_) async => Left(failure));

    final result = await useCase(tag);

    expect(result, Left(failure));

    verify(repository.insertTag(tag));
    verifyNoMoreInteractions(repository);
  });
}
