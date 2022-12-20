// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:local_database/src/model/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQFLiteDB {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('admin.db');
    return _database!;
  }

  static Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  static Future _createDB(Database db, int version) async {
    // const idType = 'TEXT PRIMARY KEY';
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    // final boolType = 'BOOLEAN NOT NULL';
    try {
      await db.execute('''
              CREATE TABLE $tableAdmin ( 
              ${AdminFields.id} $idType,              
              ${AdminFields.name} $textType,
              ${AdminFields.address} $textType,
              ${AdminFields.email} $textType,            
              ${AdminFields.phone} $textType,
              ${AdminFields.slogan} $textType
              )
              ''');
      await db.insert(tableAdmin, demoAdmin.toJson());
    } catch (e) {
      log(e.toString());
    }
  }

  // static Future<bool> create() async {
  //   try {
  //     await _database?.insert(tableAdmin, demoAdmin.toJson());
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  // static Future<List<Admin>> selectAll() async {
  //   const orderBy = '${AdminFields.id} ASC';
  //   final result = await _database!.query(tableAdmin, orderBy: orderBy);
  //   return result.map((json) => Admin.fromJson(json)).toList();
  // }

  static Future<Admin> readOne() async {
    try {
      // const orderBy = '${AdminFields.id} ASC';
      // final result = await _database!.rawQuery('SELECT * FROM $tableAdmin');
      // final result = await _database!.query(tableAdmin);
      // log(result.toString());
      // final list = result.map((json) => Admin.fromJson(json)).toList();
      final maps = await _database!.query(
        tableAdmin,
        columns: AdminFields.values,
        where: '${AdminFields.id} = ?',
        whereArgs: [0],
      );

      if (maps.isNotEmpty) {
        return Admin.fromJson(maps.first);
      } else {
        throw Exception('ID admin_local not found');
      }
      // return list[0];
    } catch (e) {
      log(e.toString());
      return demoAdmin;
    }
  }

  static Future<bool> update(Admin admin) async {
    try {
      _database!.update(
        tableAdmin,
        admin.toJson(),
        where: '${AdminFields.id} = ?',
        whereArgs: [admin.id],
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<int> delete(int id) async {
    return await _database!.delete(
      tableAdmin,
      where: '${AdminFields.id} = ?',
      whereArgs: [id],
    );
  }
}

Admin demoAdmin = const Admin(
    id: 0, slogan: '', address: '', name: 'Isumi', phone: '', email: '');
