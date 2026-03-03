import 'package:drift/drift.dart';

class ClothingItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get imagePath => text()();
  TextColumn get category => text()();
  TextColumn get subCategory => text().nullable()();
  IntColumn get warmthLevel => integer().withDefault(const Constant(1))();
  TextColumn get style => text().withDefault(const Constant('casual'))();

  TextColumn get color => text().withDefault(const Constant('Не указан'))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Outfits extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get description => text().nullable()(); 
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  
  IntColumn get topId => integer().nullable().references(ClothingItems, #id)();
  IntColumn get bottomId => integer().nullable().references(ClothingItems, #id)();
  IntColumn get shoesId => integer().nullable().references(ClothingItems, #id)();
  IntColumn get outerwearId => integer().nullable().references(ClothingItems, #id)();
  IntColumn get accessoryId => integer().nullable().references(ClothingItems, #id)();
}