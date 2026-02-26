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
