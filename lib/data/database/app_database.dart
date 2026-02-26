import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [ClothingItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  Future<List<ClothingItem>> getAllItems() => select(clothingItems).get();

  Future<List<ClothingItem>> getItemsByCategory(String category) {
    return (select(
      clothingItems,
    )..where((t) => t.category.equals(category))).get();
  }

  Future<int> insertItem(ClothingItemsCompanion item) =>
      into(clothingItems).insert(item);

  Future<int> deleteItem(int id) =>
      (delete(clothingItems)..where((t) => t.id.equals(id))).go();

  Future<bool> updateItem(ClothingItem item) =>
      update(clothingItems).replace(item);

  Stream<ClothingItem> watchItem(int id) {
    return (select(clothingItems)..where((t) => t.id.equals(id))).watchSingle();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
