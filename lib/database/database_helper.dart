

import 'dart:ffi';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  static Database? _database;
  String? path;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initSingleDigitDatabase();
    return _database!;
  }


  Future<Database> _initSingleDigitDatabase() async {
    String path = join(await getDatabasesPath(), 'theesqure_user.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE product (
        id INTEGER,
        product_name TEXT,
        price TEXT,
        strike TEXT,
        offer INTEGER,
        quantity TEXT,
        qty INTEGER,
        variant TEXT,
        variantValue TEXT,
        userId TEXT,
        cartId TEXT,
        unit TEXT,
        shopId TEXT,
        image TEXT,
        tax TEXT,
        discount TEXT,
        packingCharge INTEGER,
        addon TEXT
      )
    ''');
  }


  Future<void> deleteTableCartValues() async {
    final db = await database;
    await db.delete('product');
  }

  Future<int?> getCartCount() async {
    final db = await database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM product'));
  }

  Future<bool> isInsertCheck(String shopId) async {
    final db = await database;
    var c = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM product'));
    if(c == 0){
      return true;
    }else{
      var count =  Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM product where shopId=$shopId'));
      if(count ==0){
        return false;
      }else{
        return true;
      }
    }
  }



  Future<int> updateTableCartValuesById(int id,int qty) async {
    final db = await database;
    return await db.update(
      'product',{'qty':qty},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateTableAddOnValuesById(int id,String addOn) async {
    final db = await database;
    return await db.update(
      'product',{'addOn':addOn},
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  Future<int> deleteTableCartValuesById(int id,) async {
    final db = await database;
    return await db.delete(
      'product',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}
