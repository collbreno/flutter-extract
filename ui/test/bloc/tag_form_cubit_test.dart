import 'package:bloc_test/bloc_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:business/business.dart';
import 'package:business/fixtures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mockito/mockito.dart';
import 'package:ui/bloc/entity_form_cubit.dart';
import 'package:ui/bloc/tag_form_cubit.dart';
import 'package:ui/models/_models.dart';
import 'package:uuid/uuid.dart';

import '_mock.mocks.dart';

void main() {
  final generatedUid = Uuid().v4();
  final tag = FixtureTag().tag1;
  late TagFormCubit cubit;
  late FutureUseCase<void, Tag> insertUseCase;
  late FutureUseCase<void, Tag> updateUseCase;
  late Uuid uid;

  setUp(() {
    insertUseCase = MockInsertTagUseCase();
    updateUseCase = MockUpdateTagUseCase();
    uid = MockUuid();
    when(uid.v4()).thenReturn(generatedUid);
  });

  group('initial state', () {
    test('new tag', () {
      cubit = TagFormCubit(
        insertTag: insertUseCase,
        updateTag: updateUseCase,
      );

      expect(
        cubit.state,
        EntityFormState(
          id: '',
          status: FormzStatus.pure,
          inputs: BuiltList([
            TagNameFormzInput.pure(''),
            ColorFormzInput.pure(),
            NullableIconFormzInput.pure(),
          ]),
        ),
      );
    });

    test('editing tag', () {
      cubit = TagFormCubit(
        insertTag: insertUseCase,
        updateTag: updateUseCase,
        tag: tag,
      );

      expect(
        cubit.state,
        EntityFormState(
          id: tag.id,
          status: FormzStatus.pure,
          inputs: BuiltList([
            TagNameFormzInput.pure(tag.name),
            ColorFormzInput.pure(tag.color),
            NullableIconFormzInput.pure(tag.icon),
          ]),
        ),
      );
    });
  });

  group('on field changed', () {
    setUp(() {
      cubit = TagFormCubit(insertTag: insertUseCase, updateTag: updateUseCase);
    });

    group('change with valid values', () {
      blocTest<TagFormCubit, EntityFormState>(
        'when tag name is changed, must emit a new state',
        build: () => cubit,
        act: (cubit) => cubit.onFieldChanged<TagNameFormzInput, String>(tag.name),
        expect: () => [
          EntityFormState(
            id: '',
            status: FormzStatus.invalid,
            inputs: BuiltList([
              TagNameFormzInput.dirty(tag.name),
              ColorFormzInput.pure(),
              NullableIconFormzInput.pure(),
            ]),
          ),
        ],
      );

      blocTest<TagFormCubit, EntityFormState>(
        'when tag color is changed, must emit a new state',
        build: () => cubit,
        act: (cubit) => cubit.onFieldChanged<ColorFormzInput, Color?>(tag.color),
        expect: () => [
          EntityFormState(
            id: '',
            status: FormzStatus.invalid,
            inputs: BuiltList([
              TagNameFormzInput.pure(''),
              ColorFormzInput.dirty(tag.color),
              NullableIconFormzInput.pure(),
            ]),
          ),
        ],
      );

      blocTest<TagFormCubit, EntityFormState>(
        'when tag icon is changed, must emit a new state',
        build: () => cubit,
        act: (cubit) => cubit.onFieldChanged<NullableIconFormzInput, IconData?>(tag.icon),
        expect: () => [
          EntityFormState(
            id: '',
            status: FormzStatus.invalid,
            inputs: BuiltList([
              TagNameFormzInput.pure(''),
              ColorFormzInput.pure(),
              NullableIconFormzInput.dirty(tag.icon),
            ]),
          ),
        ],
      );
    });

    group('change with invalid values', () {
      blocTest<TagFormCubit, EntityFormState>(
        'when tag name is changed, must emit a new state',
        build: () => cubit,
        act: (cubit) => cubit.onFieldChanged<TagNameFormzInput, String>(''),
        expect: () => [
          EntityFormState(
            id: '',
            status: FormzStatus.invalid,
            inputs: BuiltList([
              TagNameFormzInput.pure(''),
              ColorFormzInput.pure(),
              NullableIconFormzInput.pure(),
            ]),
          ),
        ],
      );

      blocTest<TagFormCubit, EntityFormState>(
        'when tag color is changed, must emit a new state',
        build: () => cubit,
        act: (cubit) => cubit.onFieldChanged<ColorFormzInput, Color?>(null),
        expect: () => [
          EntityFormState(
            id: '',
            status: FormzStatus.invalid,
            inputs: BuiltList([
              TagNameFormzInput.pure(''),
              ColorFormzInput.pure(null),
              NullableIconFormzInput.pure(),
            ]),
          ),
        ],
      );

      blocTest<TagFormCubit, EntityFormState>(
        'when tag icon is changed, must emit a new state',
        build: () => cubit,
        act: (cubit) => cubit.onFieldChanged<NullableIconFormzInput, IconData?>(CupertinoIcons.add),
        expect: () => [
          EntityFormState(
            id: '',
            status: FormzStatus.invalid,
            inputs: BuiltList([
              TagNameFormzInput.pure(''),
              ColorFormzInput.pure(),
              NullableIconFormzInput.pure(CupertinoIcons.add),
            ]),
          ),
        ],
      );
    });
  });

  group('insertion', () {
    blocTest<TagFormCubit, EntityFormState>(
      'when tag name is changed, must emit a new state',
      build: () => cubit,
      setUp: () {
        final insertedTag = tag.rebuild((p0) => p0.id = generatedUid);
        when(insertUseCase(insertedTag)).thenAnswer((_) async => Right(null));
      },
      act: (cubit) {
        cubit.onFieldChanged<TagNameFormzInput, String>(tag.name);
        cubit.onFieldChanged<ColorFormzInput, Color?>(tag.color);
        cubit.onFieldChanged<NullableIconFormzInput, IconData?>(tag.icon);
        cubit.onSubmitted();
      },
      skip: 3,
      expect: () => [
        EntityFormState(
          id: '',
          status: FormzStatus.valid,
          inputs: BuiltList([
            TagNameFormzInput.dirty(tag.name),
            ColorFormzInput.dirty(tag.color),
            NullableIconFormzInput.dirty(tag.icon),
          ]),
        ),
        EntityFormState(
          id: '',
          status: FormzStatus.submissionInProgress,
          inputs: BuiltList([
            TagNameFormzInput.dirty(tag.name),
            ColorFormzInput.dirty(tag.color),
            NullableIconFormzInput.dirty(tag.icon),
          ]),
        ),
        EntityFormState(
          id: '',
          status: FormzStatus.submissionSuccess,
          inputs: BuiltList([
            TagNameFormzInput.dirty(tag.name),
            ColorFormzInput.dirty(tag.color),
            NullableIconFormzInput.dirty(tag.icon),
          ]),
        ),
        EntityFormState(
          id: '',
          status: FormzStatus.pure,
          inputs: BuiltList([
            TagNameFormzInput.pure(''),
            ColorFormzInput.pure(),
            NullableIconFormzInput.pure(),
          ]),
        ),
      ],
    );
  });
}
