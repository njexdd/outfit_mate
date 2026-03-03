import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [ClothingItems, Outfits])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 3) {
          await m.createTable(outfits);
        }
      },
    );
  }

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

  Future<int> insertOutfit(OutfitsCompanion outfit) {
    return into(outfits).insert(outfit);
  }

  Stream<List<Outfit>> watchAllOutfits() {
    return (select(outfits)
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
        .watch();
  }

  Stream<List<Outfit>> watchFavoriteOutfits() {
    return (select(outfits)
      ..where((t) => t.isFavorite.equals(true)) // Фильтруем только лайкнутые
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
      .watch();
  }

  Future<int> deleteOutfit(int id) {
    return (delete(outfits)..where((t) => t.id.equals(id))).go();
  }
  
  Future<void> toggleFavorite(int id, bool isFav) {
    return (update(outfits)..where((t) => t.id.equals(id))).write(
      OutfitsCompanion(isFavorite: Value(isFav)),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
