// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final int iconId;
  Category({@required this.id, @required this.name, @required this.iconId});
  factory Category.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Category(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      iconId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}icon_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || iconId != null) {
      map['icon_id'] = Variable<int>(iconId);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      iconId:
          iconId == null && nullToAbsent ? const Value.absent() : Value(iconId),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      iconId: serializer.fromJson<int>(json['iconId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'iconId': serializer.toJson<int>(iconId),
    };
  }

  Category copyWith({int id, String name, int iconId}) => Category(
        id: id ?? this.id,
        name: name ?? this.name,
        iconId: iconId ?? this.iconId,
      );
  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconId: $iconId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(name.hashCode, iconId.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.iconId == this.iconId);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> iconId;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.iconId = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required int iconId,
  })  : name = Value(name),
        iconId = Value(iconId);
  static Insertable<Category> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<int> iconId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (iconId != null) 'icon_id': iconId,
    });
  }

  CategoriesCompanion copyWith(
      {Value<int> id, Value<String> name, Value<int> iconId}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      iconId: iconId ?? this.iconId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (iconId.present) {
      map['icon_id'] = Variable<int>(iconId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconId: $iconId')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  final GeneratedDatabase _db;
  final String _alias;
  $CategoriesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        minTextLength: 1, maxTextLength: 40);
  }

  final VerificationMeta _iconIdMeta = const VerificationMeta('iconId');
  GeneratedIntColumn _iconId;
  @override
  GeneratedIntColumn get iconId => _iconId ??= _constructIconId();
  GeneratedIntColumn _constructIconId() {
    return GeneratedIntColumn('icon_id', $tableName, false,
        $customConstraints: 'REFERENCES icons(id)');
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, iconId];
  @override
  $CategoriesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'categories';
  @override
  final String actualTableName = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon_id')) {
      context.handle(_iconIdMeta,
          iconId.isAcceptableOrUnknown(data['icon_id'], _iconIdMeta));
    } else if (isInserting) {
      context.missing(_iconIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Category.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(_db, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final String description;
  final int value;
  final DateTime date;
  final int paymentMethodId;
  final int subcategoryId;
  final int storeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  Expense(
      {@required this.id,
      @required this.description,
      @required this.value,
      @required this.date,
      @required this.paymentMethodId,
      @required this.subcategoryId,
      this.storeId,
      @required this.createdAt,
      @required this.updatedAt});
  factory Expense.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return Expense(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      description: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
      value: intType.mapFromDatabaseResponse(data['${effectivePrefix}value']),
      date:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
      paymentMethodId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}payment_method_id']),
      subcategoryId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}subcategory_id']),
      storeId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}store_id']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<int>(value);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    if (!nullToAbsent || paymentMethodId != null) {
      map['payment_method_id'] = Variable<int>(paymentMethodId);
    }
    if (!nullToAbsent || subcategoryId != null) {
      map['subcategory_id'] = Variable<int>(subcategoryId);
    }
    if (!nullToAbsent || storeId != null) {
      map['store_id'] = Variable<int>(storeId);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      paymentMethodId: paymentMethodId == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethodId),
      subcategoryId: subcategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(subcategoryId),
      storeId: storeId == null && nullToAbsent
          ? const Value.absent()
          : Value(storeId),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Expense.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      description: serializer.fromJson<String>(json['description']),
      value: serializer.fromJson<int>(json['value']),
      date: serializer.fromJson<DateTime>(json['date']),
      paymentMethodId: serializer.fromJson<int>(json['paymentMethodId']),
      subcategoryId: serializer.fromJson<int>(json['subcategoryId']),
      storeId: serializer.fromJson<int>(json['storeId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'description': serializer.toJson<String>(description),
      'value': serializer.toJson<int>(value),
      'date': serializer.toJson<DateTime>(date),
      'paymentMethodId': serializer.toJson<int>(paymentMethodId),
      'subcategoryId': serializer.toJson<int>(subcategoryId),
      'storeId': serializer.toJson<int>(storeId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Expense copyWith(
          {int id,
          String description,
          int value,
          DateTime date,
          int paymentMethodId,
          int subcategoryId,
          int storeId,
          DateTime createdAt,
          DateTime updatedAt}) =>
      Expense(
        id: id ?? this.id,
        description: description ?? this.description,
        value: value ?? this.value,
        date: date ?? this.date,
        paymentMethodId: paymentMethodId ?? this.paymentMethodId,
        subcategoryId: subcategoryId ?? this.subcategoryId,
        storeId: storeId ?? this.storeId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('value: $value, ')
          ..write('date: $date, ')
          ..write('paymentMethodId: $paymentMethodId, ')
          ..write('subcategoryId: $subcategoryId, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          description.hashCode,
          $mrjc(
              value.hashCode,
              $mrjc(
                  date.hashCode,
                  $mrjc(
                      paymentMethodId.hashCode,
                      $mrjc(
                          subcategoryId.hashCode,
                          $mrjc(
                              storeId.hashCode,
                              $mrjc(createdAt.hashCode,
                                  updatedAt.hashCode)))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.description == this.description &&
          other.value == this.value &&
          other.date == this.date &&
          other.paymentMethodId == this.paymentMethodId &&
          other.subcategoryId == this.subcategoryId &&
          other.storeId == this.storeId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<String> description;
  final Value<int> value;
  final Value<DateTime> date;
  final Value<int> paymentMethodId;
  final Value<int> subcategoryId;
  final Value<int> storeId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.description = const Value.absent(),
    this.value = const Value.absent(),
    this.date = const Value.absent(),
    this.paymentMethodId = const Value.absent(),
    this.subcategoryId = const Value.absent(),
    this.storeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    @required String description,
    @required int value,
    @required DateTime date,
    @required int paymentMethodId,
    @required int subcategoryId,
    this.storeId = const Value.absent(),
    @required DateTime createdAt,
    @required DateTime updatedAt,
  })  : description = Value(description),
        value = Value(value),
        date = Value(date),
        paymentMethodId = Value(paymentMethodId),
        subcategoryId = Value(subcategoryId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Expense> custom({
    Expression<int> id,
    Expression<String> description,
    Expression<int> value,
    Expression<DateTime> date,
    Expression<int> paymentMethodId,
    Expression<int> subcategoryId,
    Expression<int> storeId,
    Expression<DateTime> createdAt,
    Expression<DateTime> updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (description != null) 'description': description,
      if (value != null) 'value': value,
      if (date != null) 'date': date,
      if (paymentMethodId != null) 'payment_method_id': paymentMethodId,
      if (subcategoryId != null) 'subcategory_id': subcategoryId,
      if (storeId != null) 'store_id': storeId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ExpensesCompanion copyWith(
      {Value<int> id,
      Value<String> description,
      Value<int> value,
      Value<DateTime> date,
      Value<int> paymentMethodId,
      Value<int> subcategoryId,
      Value<int> storeId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt}) {
    return ExpensesCompanion(
      id: id ?? this.id,
      description: description ?? this.description,
      value: value ?? this.value,
      date: date ?? this.date,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      storeId: storeId ?? this.storeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (paymentMethodId.present) {
      map['payment_method_id'] = Variable<int>(paymentMethodId.value);
    }
    if (subcategoryId.present) {
      map['subcategory_id'] = Variable<int>(subcategoryId.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<int>(storeId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('value: $value, ')
          ..write('date: $date, ')
          ..write('paymentMethodId: $paymentMethodId, ')
          ..write('subcategoryId: $subcategoryId, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  final GeneratedDatabase _db;
  final String _alias;
  $ExpensesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  GeneratedTextColumn _description;
  @override
  GeneratedTextColumn get description =>
      _description ??= _constructDescription();
  GeneratedTextColumn _constructDescription() {
    return GeneratedTextColumn('description', $tableName, false,
        minTextLength: 1, maxTextLength: 400);
  }

  final VerificationMeta _valueMeta = const VerificationMeta('value');
  GeneratedIntColumn _value;
  @override
  GeneratedIntColumn get value => _value ??= _constructValue();
  GeneratedIntColumn _constructValue() {
    return GeneratedIntColumn(
      'value',
      $tableName,
      false,
    );
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedDateTimeColumn _date;
  @override
  GeneratedDateTimeColumn get date => _date ??= _constructDate();
  GeneratedDateTimeColumn _constructDate() {
    return GeneratedDateTimeColumn(
      'date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _paymentMethodIdMeta =
      const VerificationMeta('paymentMethodId');
  GeneratedIntColumn _paymentMethodId;
  @override
  GeneratedIntColumn get paymentMethodId =>
      _paymentMethodId ??= _constructPaymentMethodId();
  GeneratedIntColumn _constructPaymentMethodId() {
    return GeneratedIntColumn('payment_method_id', $tableName, false,
        $customConstraints: 'REFERENCES payment_methods(id)');
  }

  final VerificationMeta _subcategoryIdMeta =
      const VerificationMeta('subcategoryId');
  GeneratedIntColumn _subcategoryId;
  @override
  GeneratedIntColumn get subcategoryId =>
      _subcategoryId ??= _constructSubcategoryId();
  GeneratedIntColumn _constructSubcategoryId() {
    return GeneratedIntColumn('subcategory_id', $tableName, false,
        $customConstraints: 'REFERENCES subcategories(id)');
  }

  final VerificationMeta _storeIdMeta = const VerificationMeta('storeId');
  GeneratedIntColumn _storeId;
  @override
  GeneratedIntColumn get storeId => _storeId ??= _constructStoreId();
  GeneratedIntColumn _constructStoreId() {
    return GeneratedIntColumn('store_id', $tableName, true,
        $customConstraints: 'NULL REFERENCES stores(id)');
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedDateTimeColumn _createdAt;
  @override
  GeneratedDateTimeColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedDateTimeColumn _constructCreatedAt() {
    return GeneratedDateTimeColumn(
      'created_at',
      $tableName,
      false,
    );
  }

  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  GeneratedDateTimeColumn _updatedAt;
  @override
  GeneratedDateTimeColumn get updatedAt => _updatedAt ??= _constructUpdatedAt();
  GeneratedDateTimeColumn _constructUpdatedAt() {
    return GeneratedDateTimeColumn(
      'updated_at',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        description,
        value,
        date,
        paymentMethodId,
        subcategoryId,
        storeId,
        createdAt,
        updatedAt
      ];
  @override
  $ExpensesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'expenses';
  @override
  final String actualTableName = 'expenses';
  @override
  VerificationContext validateIntegrity(Insertable<Expense> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description'], _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value'], _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date'], _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('payment_method_id')) {
      context.handle(
          _paymentMethodIdMeta,
          paymentMethodId.isAcceptableOrUnknown(
              data['payment_method_id'], _paymentMethodIdMeta));
    } else if (isInserting) {
      context.missing(_paymentMethodIdMeta);
    }
    if (data.containsKey('subcategory_id')) {
      context.handle(
          _subcategoryIdMeta,
          subcategoryId.isAcceptableOrUnknown(
              data['subcategory_id'], _subcategoryIdMeta));
    } else if (isInserting) {
      context.missing(_subcategoryIdMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(_storeIdMeta,
          storeId.isAcceptableOrUnknown(data['store_id'], _storeIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at'], _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at'], _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Expense.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(_db, alias);
  }
}

class Icon extends DataClass implements Insertable<Icon> {
  final int id;
  final String name;
  final String family;
  Icon({@required this.id, @required this.name, @required this.family});
  factory Icon.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Icon(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      family:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}family']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || family != null) {
      map['family'] = Variable<String>(family);
    }
    return map;
  }

  IconsCompanion toCompanion(bool nullToAbsent) {
    return IconsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      family:
          family == null && nullToAbsent ? const Value.absent() : Value(family),
    );
  }

  factory Icon.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Icon(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      family: serializer.fromJson<String>(json['family']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'family': serializer.toJson<String>(family),
    };
  }

  Icon copyWith({int id, String name, String family}) => Icon(
        id: id ?? this.id,
        name: name ?? this.name,
        family: family ?? this.family,
      );
  @override
  String toString() {
    return (StringBuffer('Icon(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('family: $family')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(name.hashCode, family.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Icon &&
          other.id == this.id &&
          other.name == this.name &&
          other.family == this.family);
}

class IconsCompanion extends UpdateCompanion<Icon> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> family;
  const IconsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.family = const Value.absent(),
  });
  IconsCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required String family,
  })  : name = Value(name),
        family = Value(family);
  static Insertable<Icon> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<String> family,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (family != null) 'family': family,
    });
  }

  IconsCompanion copyWith(
      {Value<int> id, Value<String> name, Value<String> family}) {
    return IconsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      family: family ?? this.family,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (family.present) {
      map['family'] = Variable<String>(family.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IconsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('family: $family')
          ..write(')'))
        .toString();
  }
}

class $IconsTable extends Icons with TableInfo<$IconsTable, Icon> {
  final GeneratedDatabase _db;
  final String _alias;
  $IconsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        minTextLength: 1, maxTextLength: 40);
  }

  final VerificationMeta _familyMeta = const VerificationMeta('family');
  GeneratedTextColumn _family;
  @override
  GeneratedTextColumn get family => _family ??= _constructFamily();
  GeneratedTextColumn _constructFamily() {
    return GeneratedTextColumn('family', $tableName, false,
        minTextLength: 1, maxTextLength: 40);
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, family];
  @override
  $IconsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'icons';
  @override
  final String actualTableName = 'icons';
  @override
  VerificationContext validateIntegrity(Insertable<Icon> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('family')) {
      context.handle(_familyMeta,
          family.isAcceptableOrUnknown(data['family'], _familyMeta));
    } else if (isInserting) {
      context.missing(_familyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Icon map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Icon.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $IconsTable createAlias(String alias) {
    return $IconsTable(_db, alias);
  }
}

class PaymentMethod extends DataClass implements Insertable<PaymentMethod> {
  final int id;
  final String name;
  final int color;
  final int iconId;
  PaymentMethod(
      {@required this.id,
      @required this.name,
      @required this.color,
      this.iconId});
  factory PaymentMethod.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return PaymentMethod(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      color: intType.mapFromDatabaseResponse(data['${effectivePrefix}color']),
      iconId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}icon_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
    if (!nullToAbsent || iconId != null) {
      map['icon_id'] = Variable<int>(iconId);
    }
    return map;
  }

  PaymentMethodsCompanion toCompanion(bool nullToAbsent) {
    return PaymentMethodsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      iconId:
          iconId == null && nullToAbsent ? const Value.absent() : Value(iconId),
    );
  }

  factory PaymentMethod.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return PaymentMethod(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
      iconId: serializer.fromJson<int>(json['iconId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
      'iconId': serializer.toJson<int>(iconId),
    };
  }

  PaymentMethod copyWith({int id, String name, int color, int iconId}) =>
      PaymentMethod(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
        iconId: iconId ?? this.iconId,
      );
  @override
  String toString() {
    return (StringBuffer('PaymentMethod(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('iconId: $iconId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(name.hashCode, $mrjc(color.hashCode, iconId.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is PaymentMethod &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.iconId == this.iconId);
}

class PaymentMethodsCompanion extends UpdateCompanion<PaymentMethod> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> color;
  final Value<int> iconId;
  const PaymentMethodsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.iconId = const Value.absent(),
  });
  PaymentMethodsCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required int color,
    this.iconId = const Value.absent(),
  })  : name = Value(name),
        color = Value(color);
  static Insertable<PaymentMethod> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<int> color,
    Expression<int> iconId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (iconId != null) 'icon_id': iconId,
    });
  }

  PaymentMethodsCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<int> color,
      Value<int> iconId}) {
    return PaymentMethodsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      iconId: iconId ?? this.iconId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (iconId.present) {
      map['icon_id'] = Variable<int>(iconId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentMethodsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('iconId: $iconId')
          ..write(')'))
        .toString();
  }
}

class $PaymentMethodsTable extends PaymentMethods
    with TableInfo<$PaymentMethodsTable, PaymentMethod> {
  final GeneratedDatabase _db;
  final String _alias;
  $PaymentMethodsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        minTextLength: 1, maxTextLength: 24);
  }

  final VerificationMeta _colorMeta = const VerificationMeta('color');
  GeneratedIntColumn _color;
  @override
  GeneratedIntColumn get color => _color ??= _constructColor();
  GeneratedIntColumn _constructColor() {
    return GeneratedIntColumn(
      'color',
      $tableName,
      false,
    );
  }

  final VerificationMeta _iconIdMeta = const VerificationMeta('iconId');
  GeneratedIntColumn _iconId;
  @override
  GeneratedIntColumn get iconId => _iconId ??= _constructIconId();
  GeneratedIntColumn _constructIconId() {
    return GeneratedIntColumn('icon_id', $tableName, true,
        $customConstraints: 'NULL REFERENCES icons(id)');
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, color, iconId];
  @override
  $PaymentMethodsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'payment_methods';
  @override
  final String actualTableName = 'payment_methods';
  @override
  VerificationContext validateIntegrity(Insertable<PaymentMethod> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color'], _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('icon_id')) {
      context.handle(_iconIdMeta,
          iconId.isAcceptableOrUnknown(data['icon_id'], _iconIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentMethod map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return PaymentMethod.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $PaymentMethodsTable createAlias(String alias) {
    return $PaymentMethodsTable(_db, alias);
  }
}

class Store extends DataClass implements Insertable<Store> {
  final int id;
  final String name;
  Store({@required this.id, @required this.name});
  factory Store.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Store(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    return map;
  }

  StoresCompanion toCompanion(bool nullToAbsent) {
    return StoresCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  factory Store.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Store(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Store copyWith({int id, String name}) => Store(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('Store(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, name.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Store && other.id == this.id && other.name == this.name);
}

class StoresCompanion extends UpdateCompanion<Store> {
  final Value<int> id;
  final Value<String> name;
  const StoresCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  StoresCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
  }) : name = Value(name);
  static Insertable<Store> custom({
    Expression<int> id,
    Expression<String> name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  StoresCompanion copyWith({Value<int> id, Value<String> name}) {
    return StoresCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoresCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $StoresTable extends Stores with TableInfo<$StoresTable, Store> {
  final GeneratedDatabase _db;
  final String _alias;
  $StoresTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        minTextLength: 1, maxTextLength: 48);
  }

  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  $StoresTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'stores';
  @override
  final String actualTableName = 'stores';
  @override
  VerificationContext validateIntegrity(Insertable<Store> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Store map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Store.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $StoresTable createAlias(String alias) {
    return $StoresTable(_db, alias);
  }
}

class Subcategory extends DataClass implements Insertable<Subcategory> {
  final int id;
  final String name;
  final int iconId;
  final int parentId;
  Subcategory(
      {@required this.id,
      @required this.name,
      @required this.iconId,
      @required this.parentId});
  factory Subcategory.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Subcategory(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      iconId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}icon_id']),
      parentId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}parent_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || iconId != null) {
      map['icon_id'] = Variable<int>(iconId);
    }
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    return map;
  }

  SubcategoriesCompanion toCompanion(bool nullToAbsent) {
    return SubcategoriesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      iconId:
          iconId == null && nullToAbsent ? const Value.absent() : Value(iconId),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
    );
  }

  factory Subcategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Subcategory(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      iconId: serializer.fromJson<int>(json['iconId']),
      parentId: serializer.fromJson<int>(json['parentId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'iconId': serializer.toJson<int>(iconId),
      'parentId': serializer.toJson<int>(parentId),
    };
  }

  Subcategory copyWith({int id, String name, int iconId, int parentId}) =>
      Subcategory(
        id: id ?? this.id,
        name: name ?? this.name,
        iconId: iconId ?? this.iconId,
        parentId: parentId ?? this.parentId,
      );
  @override
  String toString() {
    return (StringBuffer('Subcategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconId: $iconId, ')
          ..write('parentId: $parentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(name.hashCode, $mrjc(iconId.hashCode, parentId.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Subcategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.iconId == this.iconId &&
          other.parentId == this.parentId);
}

class SubcategoriesCompanion extends UpdateCompanion<Subcategory> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> iconId;
  final Value<int> parentId;
  const SubcategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.iconId = const Value.absent(),
    this.parentId = const Value.absent(),
  });
  SubcategoriesCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required int iconId,
    @required int parentId,
  })  : name = Value(name),
        iconId = Value(iconId),
        parentId = Value(parentId);
  static Insertable<Subcategory> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<int> iconId,
    Expression<int> parentId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (iconId != null) 'icon_id': iconId,
      if (parentId != null) 'parent_id': parentId,
    });
  }

  SubcategoriesCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<int> iconId,
      Value<int> parentId}) {
    return SubcategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      iconId: iconId ?? this.iconId,
      parentId: parentId ?? this.parentId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (iconId.present) {
      map['icon_id'] = Variable<int>(iconId.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubcategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconId: $iconId, ')
          ..write('parentId: $parentId')
          ..write(')'))
        .toString();
  }
}

class $SubcategoriesTable extends Subcategories
    with TableInfo<$SubcategoriesTable, Subcategory> {
  final GeneratedDatabase _db;
  final String _alias;
  $SubcategoriesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        minTextLength: 1, maxTextLength: 24);
  }

  final VerificationMeta _iconIdMeta = const VerificationMeta('iconId');
  GeneratedIntColumn _iconId;
  @override
  GeneratedIntColumn get iconId => _iconId ??= _constructIconId();
  GeneratedIntColumn _constructIconId() {
    return GeneratedIntColumn('icon_id', $tableName, false,
        $customConstraints: 'REFERENCES icons(id)');
  }

  final VerificationMeta _parentIdMeta = const VerificationMeta('parentId');
  GeneratedIntColumn _parentId;
  @override
  GeneratedIntColumn get parentId => _parentId ??= _constructParentId();
  GeneratedIntColumn _constructParentId() {
    return GeneratedIntColumn('parent_id', $tableName, false,
        $customConstraints: 'REFERENCES categories(id)');
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, iconId, parentId];
  @override
  $SubcategoriesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'subcategories';
  @override
  final String actualTableName = 'subcategories';
  @override
  VerificationContext validateIntegrity(Insertable<Subcategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon_id')) {
      context.handle(_iconIdMeta,
          iconId.isAcceptableOrUnknown(data['icon_id'], _iconIdMeta));
    } else if (isInserting) {
      context.missing(_iconIdMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id'], _parentIdMeta));
    } else if (isInserting) {
      context.missing(_parentIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subcategory map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Subcategory.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $SubcategoriesTable createAlias(String alias) {
    return $SubcategoriesTable(_db, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final int id;
  final String name;
  final int color;
  final int iconId;
  Tag(
      {@required this.id,
      @required this.name,
      @required this.color,
      this.iconId});
  factory Tag.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Tag(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      color: intType.mapFromDatabaseResponse(data['${effectivePrefix}color']),
      iconId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}icon_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
    if (!nullToAbsent || iconId != null) {
      map['icon_id'] = Variable<int>(iconId);
    }
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      iconId:
          iconId == null && nullToAbsent ? const Value.absent() : Value(iconId),
    );
  }

  factory Tag.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
      iconId: serializer.fromJson<int>(json['iconId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
      'iconId': serializer.toJson<int>(iconId),
    };
  }

  Tag copyWith({int id, String name, int color, int iconId}) => Tag(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
        iconId: iconId ?? this.iconId,
      );
  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('iconId: $iconId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(name.hashCode, $mrjc(color.hashCode, iconId.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.iconId == this.iconId);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> color;
  final Value<int> iconId;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.iconId = const Value.absent(),
  });
  TagsCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required int color,
    this.iconId = const Value.absent(),
  })  : name = Value(name),
        color = Value(color);
  static Insertable<Tag> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<int> color,
    Expression<int> iconId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (iconId != null) 'icon_id': iconId,
    });
  }

  TagsCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<int> color,
      Value<int> iconId}) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      iconId: iconId ?? this.iconId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (iconId.present) {
      map['icon_id'] = Variable<int>(iconId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('iconId: $iconId')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  final GeneratedDatabase _db;
  final String _alias;
  $TagsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        minTextLength: 1, maxTextLength: 24);
  }

  final VerificationMeta _colorMeta = const VerificationMeta('color');
  GeneratedIntColumn _color;
  @override
  GeneratedIntColumn get color => _color ??= _constructColor();
  GeneratedIntColumn _constructColor() {
    return GeneratedIntColumn(
      'color',
      $tableName,
      false,
    );
  }

  final VerificationMeta _iconIdMeta = const VerificationMeta('iconId');
  GeneratedIntColumn _iconId;
  @override
  GeneratedIntColumn get iconId => _iconId ??= _constructIconId();
  GeneratedIntColumn _constructIconId() {
    return GeneratedIntColumn('icon_id', $tableName, true,
        $customConstraints: 'NULL REFERENCES icons(id)');
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, color, iconId];
  @override
  $TagsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'tags';
  @override
  final String actualTableName = 'tags';
  @override
  VerificationContext validateIntegrity(Insertable<Tag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color'], _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('icon_id')) {
      context.handle(_iconIdMeta,
          iconId.isAcceptableOrUnknown(data['icon_id'], _iconIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Tag.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(_db, alias);
  }
}

class ExpenseTag extends DataClass implements Insertable<ExpenseTag> {
  final int expenseId;
  final int tagId;
  final DateTime createdAt;
  ExpenseTag(
      {@required this.expenseId,
      @required this.tagId,
      @required this.createdAt});
  factory ExpenseTag.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return ExpenseTag(
      expenseId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}expense_id']),
      tagId: intType.mapFromDatabaseResponse(data['${effectivePrefix}tag_id']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || expenseId != null) {
      map['expense_id'] = Variable<int>(expenseId);
    }
    if (!nullToAbsent || tagId != null) {
      map['tag_id'] = Variable<int>(tagId);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  ExpenseTagsCompanion toCompanion(bool nullToAbsent) {
    return ExpenseTagsCompanion(
      expenseId: expenseId == null && nullToAbsent
          ? const Value.absent()
          : Value(expenseId),
      tagId:
          tagId == null && nullToAbsent ? const Value.absent() : Value(tagId),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory ExpenseTag.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ExpenseTag(
      expenseId: serializer.fromJson<int>(json['expenseId']),
      tagId: serializer.fromJson<int>(json['tagId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'expenseId': serializer.toJson<int>(expenseId),
      'tagId': serializer.toJson<int>(tagId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExpenseTag copyWith({int expenseId, int tagId, DateTime createdAt}) =>
      ExpenseTag(
        expenseId: expenseId ?? this.expenseId,
        tagId: tagId ?? this.tagId,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('ExpenseTag(')
          ..write('expenseId: $expenseId, ')
          ..write('tagId: $tagId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf(
      $mrjc(expenseId.hashCode, $mrjc(tagId.hashCode, createdAt.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is ExpenseTag &&
          other.expenseId == this.expenseId &&
          other.tagId == this.tagId &&
          other.createdAt == this.createdAt);
}

class ExpenseTagsCompanion extends UpdateCompanion<ExpenseTag> {
  final Value<int> expenseId;
  final Value<int> tagId;
  final Value<DateTime> createdAt;
  const ExpenseTagsCompanion({
    this.expenseId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ExpenseTagsCompanion.insert({
    @required int expenseId,
    @required int tagId,
    @required DateTime createdAt,
  })  : expenseId = Value(expenseId),
        tagId = Value(tagId),
        createdAt = Value(createdAt);
  static Insertable<ExpenseTag> custom({
    Expression<int> expenseId,
    Expression<int> tagId,
    Expression<DateTime> createdAt,
  }) {
    return RawValuesInsertable({
      if (expenseId != null) 'expense_id': expenseId,
      if (tagId != null) 'tag_id': tagId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ExpenseTagsCompanion copyWith(
      {Value<int> expenseId, Value<int> tagId, Value<DateTime> createdAt}) {
    return ExpenseTagsCompanion(
      expenseId: expenseId ?? this.expenseId,
      tagId: tagId ?? this.tagId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (expenseId.present) {
      map['expense_id'] = Variable<int>(expenseId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseTagsCompanion(')
          ..write('expenseId: $expenseId, ')
          ..write('tagId: $tagId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ExpenseTagsTable extends ExpenseTags
    with TableInfo<$ExpenseTagsTable, ExpenseTag> {
  final GeneratedDatabase _db;
  final String _alias;
  $ExpenseTagsTable(this._db, [this._alias]);
  final VerificationMeta _expenseIdMeta = const VerificationMeta('expenseId');
  GeneratedIntColumn _expenseId;
  @override
  GeneratedIntColumn get expenseId => _expenseId ??= _constructExpenseId();
  GeneratedIntColumn _constructExpenseId() {
    return GeneratedIntColumn('expense_id', $tableName, false,
        $customConstraints: 'REFERENCES expenses(id)');
  }

  final VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  GeneratedIntColumn _tagId;
  @override
  GeneratedIntColumn get tagId => _tagId ??= _constructTagId();
  GeneratedIntColumn _constructTagId() {
    return GeneratedIntColumn('tag_id', $tableName, false,
        $customConstraints: 'REFERENCES tags(id)');
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedDateTimeColumn _createdAt;
  @override
  GeneratedDateTimeColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedDateTimeColumn _constructCreatedAt() {
    return GeneratedDateTimeColumn(
      'created_at',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [expenseId, tagId, createdAt];
  @override
  $ExpenseTagsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'expense_tags';
  @override
  final String actualTableName = 'expense_tags';
  @override
  VerificationContext validateIntegrity(Insertable<ExpenseTag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('expense_id')) {
      context.handle(_expenseIdMeta,
          expenseId.isAcceptableOrUnknown(data['expense_id'], _expenseIdMeta));
    } else if (isInserting) {
      context.missing(_expenseIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
          _tagIdMeta, tagId.isAcceptableOrUnknown(data['tag_id'], _tagIdMeta));
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at'], _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {expenseId, tagId};
  @override
  ExpenseTag map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return ExpenseTag.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $ExpenseTagsTable createAlias(String alias) {
    return $ExpenseTagsTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $CategoriesTable _categories;
  $CategoriesTable get categories => _categories ??= $CategoriesTable(this);
  $ExpensesTable _expenses;
  $ExpensesTable get expenses => _expenses ??= $ExpensesTable(this);
  $IconsTable _icons;
  $IconsTable get icons => _icons ??= $IconsTable(this);
  $PaymentMethodsTable _paymentMethods;
  $PaymentMethodsTable get paymentMethods =>
      _paymentMethods ??= $PaymentMethodsTable(this);
  $StoresTable _stores;
  $StoresTable get stores => _stores ??= $StoresTable(this);
  $SubcategoriesTable _subcategories;
  $SubcategoriesTable get subcategories =>
      _subcategories ??= $SubcategoriesTable(this);
  $TagsTable _tags;
  $TagsTable get tags => _tags ??= $TagsTable(this);
  $ExpenseTagsTable _expenseTags;
  $ExpenseTagsTable get expenseTags => _expenseTags ??= $ExpenseTagsTable(this);
  CategoryDao _categoryDao;
  CategoryDao get categoryDao =>
      _categoryDao ??= CategoryDao(this as AppDatabase);
  SubcategoryDao _subcategoryDao;
  SubcategoryDao get subcategoryDao =>
      _subcategoryDao ??= SubcategoryDao(this as AppDatabase);
  ExpenseDao _expenseDao;
  ExpenseDao get expenseDao => _expenseDao ??= ExpenseDao(this as AppDatabase);
  IconDao _iconDao;
  IconDao get iconDao => _iconDao ??= IconDao(this as AppDatabase);
  StoreDao _storeDao;
  StoreDao get storeDao => _storeDao ??= StoreDao(this as AppDatabase);
  PaymentMethodDao _paymentMethodDao;
  PaymentMethodDao get paymentMethodDao =>
      _paymentMethodDao ??= PaymentMethodDao(this as AppDatabase);
  TagDao _tagDao;
  TagDao get tagDao => _tagDao ??= TagDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        categories,
        expenses,
        icons,
        paymentMethods,
        stores,
        subcategories,
        tags,
        expenseTags
      ];
}
