// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ClothingItemsTable extends ClothingItems
    with TableInfo<$ClothingItemsTable, ClothingItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClothingItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subCategoryMeta = const VerificationMeta(
    'subCategory',
  );
  @override
  late final GeneratedColumn<String> subCategory = GeneratedColumn<String>(
    'sub_category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _warmthLevelMeta = const VerificationMeta(
    'warmthLevel',
  );
  @override
  late final GeneratedColumn<int> warmthLevel = GeneratedColumn<int>(
    'warmth_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _styleMeta = const VerificationMeta('style');
  @override
  late final GeneratedColumn<String> style = GeneratedColumn<String>(
    'style',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('casual'),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Не указан'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    imagePath,
    category,
    subCategory,
    warmthLevel,
    style,
    color,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clothing_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClothingItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    } else if (isInserting) {
      context.missing(_imagePathMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('sub_category')) {
      context.handle(
        _subCategoryMeta,
        subCategory.isAcceptableOrUnknown(
          data['sub_category']!,
          _subCategoryMeta,
        ),
      );
    }
    if (data.containsKey('warmth_level')) {
      context.handle(
        _warmthLevelMeta,
        warmthLevel.isAcceptableOrUnknown(
          data['warmth_level']!,
          _warmthLevelMeta,
        ),
      );
    }
    if (data.containsKey('style')) {
      context.handle(
        _styleMeta,
        style.isAcceptableOrUnknown(data['style']!, _styleMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClothingItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClothingItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      subCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sub_category'],
      ),
      warmthLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}warmth_level'],
      )!,
      style: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}style'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ClothingItemsTable createAlias(String alias) {
    return $ClothingItemsTable(attachedDatabase, alias);
  }
}

class ClothingItem extends DataClass implements Insertable<ClothingItem> {
  final int id;
  final String name;
  final String imagePath;
  final String category;
  final String? subCategory;
  final int warmthLevel;
  final String style;
  final String color;
  final DateTime createdAt;
  const ClothingItem({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.category,
    this.subCategory,
    required this.warmthLevel,
    required this.style,
    required this.color,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['image_path'] = Variable<String>(imagePath);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || subCategory != null) {
      map['sub_category'] = Variable<String>(subCategory);
    }
    map['warmth_level'] = Variable<int>(warmthLevel);
    map['style'] = Variable<String>(style);
    map['color'] = Variable<String>(color);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ClothingItemsCompanion toCompanion(bool nullToAbsent) {
    return ClothingItemsCompanion(
      id: Value(id),
      name: Value(name),
      imagePath: Value(imagePath),
      category: Value(category),
      subCategory: subCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(subCategory),
      warmthLevel: Value(warmthLevel),
      style: Value(style),
      color: Value(color),
      createdAt: Value(createdAt),
    );
  }

  factory ClothingItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClothingItem(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
      category: serializer.fromJson<String>(json['category']),
      subCategory: serializer.fromJson<String?>(json['subCategory']),
      warmthLevel: serializer.fromJson<int>(json['warmthLevel']),
      style: serializer.fromJson<String>(json['style']),
      color: serializer.fromJson<String>(json['color']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'imagePath': serializer.toJson<String>(imagePath),
      'category': serializer.toJson<String>(category),
      'subCategory': serializer.toJson<String?>(subCategory),
      'warmthLevel': serializer.toJson<int>(warmthLevel),
      'style': serializer.toJson<String>(style),
      'color': serializer.toJson<String>(color),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ClothingItem copyWith({
    int? id,
    String? name,
    String? imagePath,
    String? category,
    Value<String?> subCategory = const Value.absent(),
    int? warmthLevel,
    String? style,
    String? color,
    DateTime? createdAt,
  }) => ClothingItem(
    id: id ?? this.id,
    name: name ?? this.name,
    imagePath: imagePath ?? this.imagePath,
    category: category ?? this.category,
    subCategory: subCategory.present ? subCategory.value : this.subCategory,
    warmthLevel: warmthLevel ?? this.warmthLevel,
    style: style ?? this.style,
    color: color ?? this.color,
    createdAt: createdAt ?? this.createdAt,
  );
  ClothingItem copyWithCompanion(ClothingItemsCompanion data) {
    return ClothingItem(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      category: data.category.present ? data.category.value : this.category,
      subCategory: data.subCategory.present
          ? data.subCategory.value
          : this.subCategory,
      warmthLevel: data.warmthLevel.present
          ? data.warmthLevel.value
          : this.warmthLevel,
      style: data.style.present ? data.style.value : this.style,
      color: data.color.present ? data.color.value : this.color,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClothingItem(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imagePath: $imagePath, ')
          ..write('category: $category, ')
          ..write('subCategory: $subCategory, ')
          ..write('warmthLevel: $warmthLevel, ')
          ..write('style: $style, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    imagePath,
    category,
    subCategory,
    warmthLevel,
    style,
    color,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClothingItem &&
          other.id == this.id &&
          other.name == this.name &&
          other.imagePath == this.imagePath &&
          other.category == this.category &&
          other.subCategory == this.subCategory &&
          other.warmthLevel == this.warmthLevel &&
          other.style == this.style &&
          other.color == this.color &&
          other.createdAt == this.createdAt);
}

class ClothingItemsCompanion extends UpdateCompanion<ClothingItem> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> imagePath;
  final Value<String> category;
  final Value<String?> subCategory;
  final Value<int> warmthLevel;
  final Value<String> style;
  final Value<String> color;
  final Value<DateTime> createdAt;
  const ClothingItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.category = const Value.absent(),
    this.subCategory = const Value.absent(),
    this.warmthLevel = const Value.absent(),
    this.style = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ClothingItemsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String imagePath,
    required String category,
    this.subCategory = const Value.absent(),
    this.warmthLevel = const Value.absent(),
    this.style = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       imagePath = Value(imagePath),
       category = Value(category);
  static Insertable<ClothingItem> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? imagePath,
    Expression<String>? category,
    Expression<String>? subCategory,
    Expression<int>? warmthLevel,
    Expression<String>? style,
    Expression<String>? color,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (imagePath != null) 'image_path': imagePath,
      if (category != null) 'category': category,
      if (subCategory != null) 'sub_category': subCategory,
      if (warmthLevel != null) 'warmth_level': warmthLevel,
      if (style != null) 'style': style,
      if (color != null) 'color': color,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ClothingItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? imagePath,
    Value<String>? category,
    Value<String?>? subCategory,
    Value<int>? warmthLevel,
    Value<String>? style,
    Value<String>? color,
    Value<DateTime>? createdAt,
  }) {
    return ClothingItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      warmthLevel: warmthLevel ?? this.warmthLevel,
      style: style ?? this.style,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
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
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (subCategory.present) {
      map['sub_category'] = Variable<String>(subCategory.value);
    }
    if (warmthLevel.present) {
      map['warmth_level'] = Variable<int>(warmthLevel.value);
    }
    if (style.present) {
      map['style'] = Variable<String>(style.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClothingItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imagePath: $imagePath, ')
          ..write('category: $category, ')
          ..write('subCategory: $subCategory, ')
          ..write('warmthLevel: $warmthLevel, ')
          ..write('style: $style, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $OutfitsTable extends Outfits with TableInfo<$OutfitsTable, Outfit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutfitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _topIdMeta = const VerificationMeta('topId');
  @override
  late final GeneratedColumn<int> topId = GeneratedColumn<int>(
    'top_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clothing_items (id)',
    ),
  );
  static const VerificationMeta _bottomIdMeta = const VerificationMeta(
    'bottomId',
  );
  @override
  late final GeneratedColumn<int> bottomId = GeneratedColumn<int>(
    'bottom_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clothing_items (id)',
    ),
  );
  static const VerificationMeta _shoesIdMeta = const VerificationMeta(
    'shoesId',
  );
  @override
  late final GeneratedColumn<int> shoesId = GeneratedColumn<int>(
    'shoes_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clothing_items (id)',
    ),
  );
  static const VerificationMeta _outerwearIdMeta = const VerificationMeta(
    'outerwearId',
  );
  @override
  late final GeneratedColumn<int> outerwearId = GeneratedColumn<int>(
    'outerwear_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clothing_items (id)',
    ),
  );
  static const VerificationMeta _accessoryIdMeta = const VerificationMeta(
    'accessoryId',
  );
  @override
  late final GeneratedColumn<int> accessoryId = GeneratedColumn<int>(
    'accessory_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clothing_items (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    description,
    isFavorite,
    topId,
    bottomId,
    shoesId,
    outerwearId,
    accessoryId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outfits';
  @override
  VerificationContext validateIntegrity(
    Insertable<Outfit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('top_id')) {
      context.handle(
        _topIdMeta,
        topId.isAcceptableOrUnknown(data['top_id']!, _topIdMeta),
      );
    }
    if (data.containsKey('bottom_id')) {
      context.handle(
        _bottomIdMeta,
        bottomId.isAcceptableOrUnknown(data['bottom_id']!, _bottomIdMeta),
      );
    }
    if (data.containsKey('shoes_id')) {
      context.handle(
        _shoesIdMeta,
        shoesId.isAcceptableOrUnknown(data['shoes_id']!, _shoesIdMeta),
      );
    }
    if (data.containsKey('outerwear_id')) {
      context.handle(
        _outerwearIdMeta,
        outerwearId.isAcceptableOrUnknown(
          data['outerwear_id']!,
          _outerwearIdMeta,
        ),
      );
    }
    if (data.containsKey('accessory_id')) {
      context.handle(
        _accessoryIdMeta,
        accessoryId.isAcceptableOrUnknown(
          data['accessory_id']!,
          _accessoryIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Outfit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Outfit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      topId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}top_id'],
      ),
      bottomId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bottom_id'],
      ),
      shoesId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shoes_id'],
      ),
      outerwearId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}outerwear_id'],
      ),
      accessoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}accessory_id'],
      ),
    );
  }

  @override
  $OutfitsTable createAlias(String alias) {
    return $OutfitsTable(attachedDatabase, alias);
  }
}

class Outfit extends DataClass implements Insertable<Outfit> {
  final int id;
  final DateTime date;
  final String? description;
  final bool isFavorite;
  final int? topId;
  final int? bottomId;
  final int? shoesId;
  final int? outerwearId;
  final int? accessoryId;
  const Outfit({
    required this.id,
    required this.date,
    this.description,
    required this.isFavorite,
    this.topId,
    this.bottomId,
    this.shoesId,
    this.outerwearId,
    this.accessoryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    if (!nullToAbsent || topId != null) {
      map['top_id'] = Variable<int>(topId);
    }
    if (!nullToAbsent || bottomId != null) {
      map['bottom_id'] = Variable<int>(bottomId);
    }
    if (!nullToAbsent || shoesId != null) {
      map['shoes_id'] = Variable<int>(shoesId);
    }
    if (!nullToAbsent || outerwearId != null) {
      map['outerwear_id'] = Variable<int>(outerwearId);
    }
    if (!nullToAbsent || accessoryId != null) {
      map['accessory_id'] = Variable<int>(accessoryId);
    }
    return map;
  }

  OutfitsCompanion toCompanion(bool nullToAbsent) {
    return OutfitsCompanion(
      id: Value(id),
      date: Value(date),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isFavorite: Value(isFavorite),
      topId: topId == null && nullToAbsent
          ? const Value.absent()
          : Value(topId),
      bottomId: bottomId == null && nullToAbsent
          ? const Value.absent()
          : Value(bottomId),
      shoesId: shoesId == null && nullToAbsent
          ? const Value.absent()
          : Value(shoesId),
      outerwearId: outerwearId == null && nullToAbsent
          ? const Value.absent()
          : Value(outerwearId),
      accessoryId: accessoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(accessoryId),
    );
  }

  factory Outfit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Outfit(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      description: serializer.fromJson<String?>(json['description']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      topId: serializer.fromJson<int?>(json['topId']),
      bottomId: serializer.fromJson<int?>(json['bottomId']),
      shoesId: serializer.fromJson<int?>(json['shoesId']),
      outerwearId: serializer.fromJson<int?>(json['outerwearId']),
      accessoryId: serializer.fromJson<int?>(json['accessoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'description': serializer.toJson<String?>(description),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'topId': serializer.toJson<int?>(topId),
      'bottomId': serializer.toJson<int?>(bottomId),
      'shoesId': serializer.toJson<int?>(shoesId),
      'outerwearId': serializer.toJson<int?>(outerwearId),
      'accessoryId': serializer.toJson<int?>(accessoryId),
    };
  }

  Outfit copyWith({
    int? id,
    DateTime? date,
    Value<String?> description = const Value.absent(),
    bool? isFavorite,
    Value<int?> topId = const Value.absent(),
    Value<int?> bottomId = const Value.absent(),
    Value<int?> shoesId = const Value.absent(),
    Value<int?> outerwearId = const Value.absent(),
    Value<int?> accessoryId = const Value.absent(),
  }) => Outfit(
    id: id ?? this.id,
    date: date ?? this.date,
    description: description.present ? description.value : this.description,
    isFavorite: isFavorite ?? this.isFavorite,
    topId: topId.present ? topId.value : this.topId,
    bottomId: bottomId.present ? bottomId.value : this.bottomId,
    shoesId: shoesId.present ? shoesId.value : this.shoesId,
    outerwearId: outerwearId.present ? outerwearId.value : this.outerwearId,
    accessoryId: accessoryId.present ? accessoryId.value : this.accessoryId,
  );
  Outfit copyWithCompanion(OutfitsCompanion data) {
    return Outfit(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      description: data.description.present
          ? data.description.value
          : this.description,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      topId: data.topId.present ? data.topId.value : this.topId,
      bottomId: data.bottomId.present ? data.bottomId.value : this.bottomId,
      shoesId: data.shoesId.present ? data.shoesId.value : this.shoesId,
      outerwearId: data.outerwearId.present
          ? data.outerwearId.value
          : this.outerwearId,
      accessoryId: data.accessoryId.present
          ? data.accessoryId.value
          : this.accessoryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Outfit(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('description: $description, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('topId: $topId, ')
          ..write('bottomId: $bottomId, ')
          ..write('shoesId: $shoesId, ')
          ..write('outerwearId: $outerwearId, ')
          ..write('accessoryId: $accessoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    description,
    isFavorite,
    topId,
    bottomId,
    shoesId,
    outerwearId,
    accessoryId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Outfit &&
          other.id == this.id &&
          other.date == this.date &&
          other.description == this.description &&
          other.isFavorite == this.isFavorite &&
          other.topId == this.topId &&
          other.bottomId == this.bottomId &&
          other.shoesId == this.shoesId &&
          other.outerwearId == this.outerwearId &&
          other.accessoryId == this.accessoryId);
}

class OutfitsCompanion extends UpdateCompanion<Outfit> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String?> description;
  final Value<bool> isFavorite;
  final Value<int?> topId;
  final Value<int?> bottomId;
  final Value<int?> shoesId;
  final Value<int?> outerwearId;
  final Value<int?> accessoryId;
  const OutfitsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.description = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.topId = const Value.absent(),
    this.bottomId = const Value.absent(),
    this.shoesId = const Value.absent(),
    this.outerwearId = const Value.absent(),
    this.accessoryId = const Value.absent(),
  });
  OutfitsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.description = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.topId = const Value.absent(),
    this.bottomId = const Value.absent(),
    this.shoesId = const Value.absent(),
    this.outerwearId = const Value.absent(),
    this.accessoryId = const Value.absent(),
  }) : date = Value(date);
  static Insertable<Outfit> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? description,
    Expression<bool>? isFavorite,
    Expression<int>? topId,
    Expression<int>? bottomId,
    Expression<int>? shoesId,
    Expression<int>? outerwearId,
    Expression<int>? accessoryId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (description != null) 'description': description,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (topId != null) 'top_id': topId,
      if (bottomId != null) 'bottom_id': bottomId,
      if (shoesId != null) 'shoes_id': shoesId,
      if (outerwearId != null) 'outerwear_id': outerwearId,
      if (accessoryId != null) 'accessory_id': accessoryId,
    });
  }

  OutfitsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<String?>? description,
    Value<bool>? isFavorite,
    Value<int?>? topId,
    Value<int?>? bottomId,
    Value<int?>? shoesId,
    Value<int?>? outerwearId,
    Value<int?>? accessoryId,
  }) {
    return OutfitsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      topId: topId ?? this.topId,
      bottomId: bottomId ?? this.bottomId,
      shoesId: shoesId ?? this.shoesId,
      outerwearId: outerwearId ?? this.outerwearId,
      accessoryId: accessoryId ?? this.accessoryId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (topId.present) {
      map['top_id'] = Variable<int>(topId.value);
    }
    if (bottomId.present) {
      map['bottom_id'] = Variable<int>(bottomId.value);
    }
    if (shoesId.present) {
      map['shoes_id'] = Variable<int>(shoesId.value);
    }
    if (outerwearId.present) {
      map['outerwear_id'] = Variable<int>(outerwearId.value);
    }
    if (accessoryId.present) {
      map['accessory_id'] = Variable<int>(accessoryId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutfitsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('description: $description, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('topId: $topId, ')
          ..write('bottomId: $bottomId, ')
          ..write('shoesId: $shoesId, ')
          ..write('outerwearId: $outerwearId, ')
          ..write('accessoryId: $accessoryId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClothingItemsTable clothingItems = $ClothingItemsTable(this);
  late final $OutfitsTable outfits = $OutfitsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [clothingItems, outfits];
}

typedef $$ClothingItemsTableCreateCompanionBuilder =
    ClothingItemsCompanion Function({
      Value<int> id,
      required String name,
      required String imagePath,
      required String category,
      Value<String?> subCategory,
      Value<int> warmthLevel,
      Value<String> style,
      Value<String> color,
      Value<DateTime> createdAt,
    });
typedef $$ClothingItemsTableUpdateCompanionBuilder =
    ClothingItemsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> imagePath,
      Value<String> category,
      Value<String?> subCategory,
      Value<int> warmthLevel,
      Value<String> style,
      Value<String> color,
      Value<DateTime> createdAt,
    });

class $$ClothingItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ClothingItemsTable> {
  $$ClothingItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subCategory => $composableBuilder(
    column: $table.subCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get warmthLevel => $composableBuilder(
    column: $table.warmthLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get style => $composableBuilder(
    column: $table.style,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ClothingItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClothingItemsTable> {
  $$ClothingItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subCategory => $composableBuilder(
    column: $table.subCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get warmthLevel => $composableBuilder(
    column: $table.warmthLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get style => $composableBuilder(
    column: $table.style,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClothingItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClothingItemsTable> {
  $$ClothingItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get subCategory => $composableBuilder(
    column: $table.subCategory,
    builder: (column) => column,
  );

  GeneratedColumn<int> get warmthLevel => $composableBuilder(
    column: $table.warmthLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get style =>
      $composableBuilder(column: $table.style, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ClothingItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClothingItemsTable,
          ClothingItem,
          $$ClothingItemsTableFilterComposer,
          $$ClothingItemsTableOrderingComposer,
          $$ClothingItemsTableAnnotationComposer,
          $$ClothingItemsTableCreateCompanionBuilder,
          $$ClothingItemsTableUpdateCompanionBuilder,
          (
            ClothingItem,
            BaseReferences<_$AppDatabase, $ClothingItemsTable, ClothingItem>,
          ),
          ClothingItem,
          PrefetchHooks Function()
        > {
  $$ClothingItemsTableTableManager(_$AppDatabase db, $ClothingItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClothingItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClothingItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClothingItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> imagePath = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> subCategory = const Value.absent(),
                Value<int> warmthLevel = const Value.absent(),
                Value<String> style = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ClothingItemsCompanion(
                id: id,
                name: name,
                imagePath: imagePath,
                category: category,
                subCategory: subCategory,
                warmthLevel: warmthLevel,
                style: style,
                color: color,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String imagePath,
                required String category,
                Value<String?> subCategory = const Value.absent(),
                Value<int> warmthLevel = const Value.absent(),
                Value<String> style = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ClothingItemsCompanion.insert(
                id: id,
                name: name,
                imagePath: imagePath,
                category: category,
                subCategory: subCategory,
                warmthLevel: warmthLevel,
                style: style,
                color: color,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ClothingItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClothingItemsTable,
      ClothingItem,
      $$ClothingItemsTableFilterComposer,
      $$ClothingItemsTableOrderingComposer,
      $$ClothingItemsTableAnnotationComposer,
      $$ClothingItemsTableCreateCompanionBuilder,
      $$ClothingItemsTableUpdateCompanionBuilder,
      (
        ClothingItem,
        BaseReferences<_$AppDatabase, $ClothingItemsTable, ClothingItem>,
      ),
      ClothingItem,
      PrefetchHooks Function()
    >;
typedef $$OutfitsTableCreateCompanionBuilder =
    OutfitsCompanion Function({
      Value<int> id,
      required DateTime date,
      Value<String?> description,
      Value<bool> isFavorite,
      Value<int?> topId,
      Value<int?> bottomId,
      Value<int?> shoesId,
      Value<int?> outerwearId,
      Value<int?> accessoryId,
    });
typedef $$OutfitsTableUpdateCompanionBuilder =
    OutfitsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<String?> description,
      Value<bool> isFavorite,
      Value<int?> topId,
      Value<int?> bottomId,
      Value<int?> shoesId,
      Value<int?> outerwearId,
      Value<int?> accessoryId,
    });

final class $$OutfitsTableReferences
    extends BaseReferences<_$AppDatabase, $OutfitsTable, Outfit> {
  $$OutfitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClothingItemsTable _topIdTable(_$AppDatabase db) => db.clothingItems
      .createAlias($_aliasNameGenerator(db.outfits.topId, db.clothingItems.id));

  $$ClothingItemsTableProcessedTableManager? get topId {
    final $_column = $_itemColumn<int>('top_id');
    if ($_column == null) return null;
    final manager = $$ClothingItemsTableTableManager(
      $_db,
      $_db.clothingItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_topIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ClothingItemsTable _bottomIdTable(_$AppDatabase db) =>
      db.clothingItems.createAlias(
        $_aliasNameGenerator(db.outfits.bottomId, db.clothingItems.id),
      );

  $$ClothingItemsTableProcessedTableManager? get bottomId {
    final $_column = $_itemColumn<int>('bottom_id');
    if ($_column == null) return null;
    final manager = $$ClothingItemsTableTableManager(
      $_db,
      $_db.clothingItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bottomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ClothingItemsTable _shoesIdTable(_$AppDatabase db) =>
      db.clothingItems.createAlias(
        $_aliasNameGenerator(db.outfits.shoesId, db.clothingItems.id),
      );

  $$ClothingItemsTableProcessedTableManager? get shoesId {
    final $_column = $_itemColumn<int>('shoes_id');
    if ($_column == null) return null;
    final manager = $$ClothingItemsTableTableManager(
      $_db,
      $_db.clothingItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shoesIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ClothingItemsTable _outerwearIdTable(_$AppDatabase db) =>
      db.clothingItems.createAlias(
        $_aliasNameGenerator(db.outfits.outerwearId, db.clothingItems.id),
      );

  $$ClothingItemsTableProcessedTableManager? get outerwearId {
    final $_column = $_itemColumn<int>('outerwear_id');
    if ($_column == null) return null;
    final manager = $$ClothingItemsTableTableManager(
      $_db,
      $_db.clothingItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_outerwearIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ClothingItemsTable _accessoryIdTable(_$AppDatabase db) =>
      db.clothingItems.createAlias(
        $_aliasNameGenerator(db.outfits.accessoryId, db.clothingItems.id),
      );

  $$ClothingItemsTableProcessedTableManager? get accessoryId {
    final $_column = $_itemColumn<int>('accessory_id');
    if ($_column == null) return null;
    final manager = $$ClothingItemsTableTableManager(
      $_db,
      $_db.clothingItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accessoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OutfitsTableFilterComposer
    extends Composer<_$AppDatabase, $OutfitsTable> {
  $$OutfitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  $$ClothingItemsTableFilterComposer get topId {
    final $$ClothingItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topId,
      referencedTable: $db.clothingItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClothingItemsTableFilterComposer(
            $db: $db,
            $table: $db.clothingItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClothingItemsTableFilterComposer get bottomId {
    final $$ClothingItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bottomId,
      referencedTable: $db.clothingItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClothingItemsTableFilterComposer(
            $db: $db,
            $table: $db.clothingItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClothingItemsTableFilterComposer get shoesId {
    final $$ClothingItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shoesId,
      referencedTable: $db.clothingItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClothingItemsTableFilterComposer(
            $db: $db,
            $table: $db.clothingItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClothingItemsTableFilterComposer get outerwearId {
    final $$ClothingItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.outerwearId,
      referencedTable: $db.clothingItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClothingItemsTableFilterComposer(
            $db: $db,
            $table: $db.clothingItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClothingItemsTableFilterComposer get accessoryId {
    final $$ClothingItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accessoryId,
      referencedTable: $db.clothingItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClothingItemsTableFilterComposer(
            $db: $db,
            $table: $db.clothingItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OutfitsTableOrderingComposer
    extends Composer<_$AppDatabase, $OutfitsTable> {
  $$OutfitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClothingItemsTableOrderingComposer get topId {
    final $$ClothingItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topId,
      referencedTable: $db.clothingItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClothingItemsTableOrderingComposer(
            $db: $db,
            $table: $db.clothingItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClothingItemsTableOrderingComposer get bottomId {
    final $$ClothingItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bottomId,
      referencedTable: $db.clothingItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClothingItemsTableOrderingComposer(
            $db: $db,
            $table: $db.clothingItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClothingItemsTableOrderingComposer get shoesId {
    final $$ClothingItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shoesId,
      referencedTable: $db.clothingItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClothingItemsTableOrderingComposer(
            $db: $db,
            $table: $db.clothingItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClothingItemsTableOrderingComposer get outerwearId {
    final $$ClothingItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.outerwearId,
      referencedTable: $db.clothingItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClothingItemsTableOrderingComposer(
            $db: $db,
            $table: $db.clothingItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClothingItemsTableOrderingComposer get accessoryId {
    final $$ClothingItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accessoryId,
      referencedTable: $db.clothingItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClothingItemsTableOrderingComposer(
            $db: $db,
            $table: $db.clothingItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OutfitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutfitsTable> {
  $$OutfitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  $$ClothingItemsTableAnnotationComposer get topId {
    final $$ClothingItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topId,
      referencedTable: $db.clothingItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClothingItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.clothingItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClothingItemsTableAnnotationComposer get bottomId {
    final $$ClothingItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bottomId,
      referencedTable: $db.clothingItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClothingItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.clothingItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClothingItemsTableAnnotationComposer get shoesId {
    final $$ClothingItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shoesId,
      referencedTable: $db.clothingItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClothingItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.clothingItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClothingItemsTableAnnotationComposer get outerwearId {
    final $$ClothingItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.outerwearId,
      referencedTable: $db.clothingItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClothingItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.clothingItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClothingItemsTableAnnotationComposer get accessoryId {
    final $$ClothingItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accessoryId,
      referencedTable: $db.clothingItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClothingItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.clothingItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OutfitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutfitsTable,
          Outfit,
          $$OutfitsTableFilterComposer,
          $$OutfitsTableOrderingComposer,
          $$OutfitsTableAnnotationComposer,
          $$OutfitsTableCreateCompanionBuilder,
          $$OutfitsTableUpdateCompanionBuilder,
          (Outfit, $$OutfitsTableReferences),
          Outfit,
          PrefetchHooks Function({
            bool topId,
            bool bottomId,
            bool shoesId,
            bool outerwearId,
            bool accessoryId,
          })
        > {
  $$OutfitsTableTableManager(_$AppDatabase db, $OutfitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutfitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutfitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutfitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int?> topId = const Value.absent(),
                Value<int?> bottomId = const Value.absent(),
                Value<int?> shoesId = const Value.absent(),
                Value<int?> outerwearId = const Value.absent(),
                Value<int?> accessoryId = const Value.absent(),
              }) => OutfitsCompanion(
                id: id,
                date: date,
                description: description,
                isFavorite: isFavorite,
                topId: topId,
                bottomId: bottomId,
                shoesId: shoesId,
                outerwearId: outerwearId,
                accessoryId: accessoryId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                Value<String?> description = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int?> topId = const Value.absent(),
                Value<int?> bottomId = const Value.absent(),
                Value<int?> shoesId = const Value.absent(),
                Value<int?> outerwearId = const Value.absent(),
                Value<int?> accessoryId = const Value.absent(),
              }) => OutfitsCompanion.insert(
                id: id,
                date: date,
                description: description,
                isFavorite: isFavorite,
                topId: topId,
                bottomId: bottomId,
                shoesId: shoesId,
                outerwearId: outerwearId,
                accessoryId: accessoryId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OutfitsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                topId = false,
                bottomId = false,
                shoesId = false,
                outerwearId = false,
                accessoryId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (topId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.topId,
                                    referencedTable: $$OutfitsTableReferences
                                        ._topIdTable(db),
                                    referencedColumn: $$OutfitsTableReferences
                                        ._topIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (bottomId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.bottomId,
                                    referencedTable: $$OutfitsTableReferences
                                        ._bottomIdTable(db),
                                    referencedColumn: $$OutfitsTableReferences
                                        ._bottomIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (shoesId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.shoesId,
                                    referencedTable: $$OutfitsTableReferences
                                        ._shoesIdTable(db),
                                    referencedColumn: $$OutfitsTableReferences
                                        ._shoesIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (outerwearId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.outerwearId,
                                    referencedTable: $$OutfitsTableReferences
                                        ._outerwearIdTable(db),
                                    referencedColumn: $$OutfitsTableReferences
                                        ._outerwearIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (accessoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.accessoryId,
                                    referencedTable: $$OutfitsTableReferences
                                        ._accessoryIdTable(db),
                                    referencedColumn: $$OutfitsTableReferences
                                        ._accessoryIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$OutfitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutfitsTable,
      Outfit,
      $$OutfitsTableFilterComposer,
      $$OutfitsTableOrderingComposer,
      $$OutfitsTableAnnotationComposer,
      $$OutfitsTableCreateCompanionBuilder,
      $$OutfitsTableUpdateCompanionBuilder,
      (Outfit, $$OutfitsTableReferences),
      Outfit,
      PrefetchHooks Function({
        bool topId,
        bool bottomId,
        bool shoesId,
        bool outerwearId,
        bool accessoryId,
      })
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClothingItemsTableTableManager get clothingItems =>
      $$ClothingItemsTableTableManager(_db, _db.clothingItems);
  $$OutfitsTableTableManager get outfits =>
      $$OutfitsTableTableManager(_db, _db.outfits);
}
