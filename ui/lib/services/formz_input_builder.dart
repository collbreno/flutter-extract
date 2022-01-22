import 'package:business/business.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:ui/models/_models.dart';
import 'package:ui/models/entity_formz_input.dart';

class FormzInputBuilder {
  FormzInputBuilder._();

  static T pureBuilder<T extends FormzInput>(T formzInput, dynamic value) {
    final type = formzInput.runtimeType;

    if (type == CategoryNameFormzInput) {
      return CategoryNameFormzInput.pure(value as String) as T;
    } else if (type == PaymentMethodNameFormzInput) {
      return PaymentMethodNameFormzInput.pure(value as String) as T;
    } else if (type == StoreNameFormzInput) {
      return StoreNameFormzInput.pure(value as String) as T;
    } else if (type == SubcategoryNameFormzInput) {
      return SubcategoryNameFormzInput.pure(value as String) as T;
    } else if (type == TagNameFormzInput) {
      return TagNameFormzInput.pure(value as String) as T;
    } else if (type == NullableIconFormzInput) {
      return NullableIconFormzInput.pure(value as IconData?) as T;
    } else if (type == IconFormzInput) {
      return IconFormzInput.pure(value as IconData?) as T;
    } else if (type == ColorFormzInput) {
      return ColorFormzInput.pure(value as Color?) as T;
    } else if (type == EntityFormzInput < Category>) {
      return EntityFormzInput<Category>.pure(value as Category) as T;
    }

    throw Exception('Pure builder not defined for type $type');
  }

  static T dirtyBuilder<T extends FormzInput>(T formzInput, dynamic value) {
    final type = formzInput.runtimeType;

    if (type == CategoryNameFormzInput) {
      return CategoryNameFormzInput.dirty(value as String) as T;
    } else if (type == PaymentMethodNameFormzInput) {
      return PaymentMethodNameFormzInput.dirty(value as String) as T;
    } else if (type == StoreNameFormzInput) {
      return StoreNameFormzInput.dirty(value as String) as T;
    } else if (type == SubcategoryNameFormzInput) {
      return SubcategoryNameFormzInput.dirty(value as String) as T;
    } else if (type == TagNameFormzInput) {
      return TagNameFormzInput.dirty(value as String) as T;
    } else if (type == NullableIconFormzInput) {
      return NullableIconFormzInput.dirty(value as IconData?) as T;
    } else if (type == IconFormzInput) {
      return IconFormzInput.dirty(value as IconData?) as T;
    } else if (type == ColorFormzInput) {
      return ColorFormzInput.dirty(value as Color?) as T;
    } else if (type == EntityFormzInput < Category>) {
      return EntityFormzInput<Category>.dirty(value as Category) as T;
    }
    throw Exception('Dirty builder not defined for type $type');
  }
}
