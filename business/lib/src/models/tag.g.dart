// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Tag> _$tagSerializer = new _$TagSerializer();

class _$TagSerializer implements StructuredSerializer<Tag> {
  @override
  final Iterable<Type> types = const [Tag, _$Tag];
  @override
  final String wireName = 'Tag';

  @override
  Iterable<Object> serialize(Serializers serializers, Tag object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'color',
      serializers.serialize(object.color, specifiedType: const FullType(Color)),
      'icon',
      serializers.serialize(object.icon,
          specifiedType: const FullType(IconData)),
    ];

    return result;
  }

  @override
  Tag deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TagBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'color':
          result.color = serializers.deserialize(value,
              specifiedType: const FullType(Color)) as Color;
          break;
        case 'icon':
          result.icon = serializers.deserialize(value,
              specifiedType: const FullType(IconData)) as IconData;
          break;
      }
    }

    return result.build();
  }
}

class _$Tag extends Tag {
  @override
  final int id;
  @override
  final String name;
  @override
  final Color color;
  @override
  final IconData icon;

  factory _$Tag([void Function(TagBuilder) updates]) =>
      (new TagBuilder()..update(updates)).build();

  _$Tag._({this.id, this.name, this.color, this.icon}) : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Tag', 'id');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('Tag', 'name');
    }
    if (color == null) {
      throw new BuiltValueNullFieldError('Tag', 'color');
    }
    if (icon == null) {
      throw new BuiltValueNullFieldError('Tag', 'icon');
    }
  }

  @override
  Tag rebuild(void Function(TagBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TagBuilder toBuilder() => new TagBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Tag &&
        id == other.id &&
        name == other.name &&
        color == other.color &&
        icon == other.icon;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc($jc(0, id.hashCode), name.hashCode), color.hashCode),
        icon.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Tag')
          ..add('id', id)
          ..add('name', name)
          ..add('color', color)
          ..add('icon', icon))
        .toString();
  }
}

class TagBuilder implements Builder<Tag, TagBuilder> {
  _$Tag _$v;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  Color _color;
  Color get color => _$this._color;
  set color(Color color) => _$this._color = color;

  IconData _icon;
  IconData get icon => _$this._icon;
  set icon(IconData icon) => _$this._icon = icon;

  TagBuilder();

  TagBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _name = _$v.name;
      _color = _$v.color;
      _icon = _$v.icon;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Tag other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Tag;
  }

  @override
  void update(void Function(TagBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Tag build() {
    final _$result =
        _$v ?? new _$Tag._(id: id, name: name, color: color, icon: icon);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
