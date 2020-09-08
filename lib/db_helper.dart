import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/cupertino.dart';
import 'package:flutter_inventory_app/models/product_model.dart' as product_model;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {

  static Database _db;

  Future<Database> get db async {
    if (_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  //Creating a database with name test.dn in your directory
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "products.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  // Creating a table name Employee with fields
  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        """CREATE TABLE product(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        name TEXT NOT NULL, 
        brand TEXT NOT NULL, 
        color TEXT NOT NULL, 
        size INTEGER NOT NULL, 
        qty INTEGER NOT NULL)""");

    await db.execute(
        """CREATE TABLE image(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        path TEXT, 
        product_id INTEGER,
        FOREIGN KEY(product_id) REFERENCES product (id) 
        ON DELETE NO ACTION ON UPDATE NO ACTION)""");

    debugPrint("Created tables");
  }

  // Get all products
  Future<List<Map<String, dynamic>>> getProducts() async {
    Database db = this.initDb();

    var result = await db.query('product');
    return result;
    
  }

  // Inser or update image
  Future<product_model.Image> insertImage(product_model.Image image) async {
    // var count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM image WHERE username = ?", [image.id]));
    Database database = await db;

    await database.insert("image", image.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);

    // await _db.update("image", image.toMap(), where: "id = ?", whereArgs: [image.id]);


    return image;
  }

  // Inser or update product
  Future<product_model.Product> insertProduct(product_model.Product product) async {
    // var count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM product WHERE username = ?", [product.id]));

    Database database = await db;

    await database.insert("product", product.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);

    // await _db.update("product", product.toMap(), where: "id = ?", whereArgs: [product.id]);

    return product;
  }

}