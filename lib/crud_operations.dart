import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;
import 'recordatorio.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database _db;
  static const String Id = 'id';
  static const String num = 'num';

  static const String fecha = 'fecha';
  static const String hora = 'hora';
  static const String nombre = 'nombre';
  static const String descripcion = 'descripcion';
  static const String tipo = 'tipo';
  static const String TABLE = 'diario';
  static const String TABLE2 = 'semanal';
  static const String TABLE3 = 'programado';
  static const String TABLE4 = 'completados';
  static const String DB_NAME = 'students01.db';

  //CREACION DE LA BASE DE DATOS (VERIFICAR EXISTENCIA)
  Future<Database> get db async {
    //SI ES DIFERENTE DE NULL RETORNARÁ LA BASE DE DATOS
    if (_db != null) {
      return _db;
    } else {
      //SI NO VAMOS A CREAR EL METODO
      _db = await initDb();
      return _db;
    }
  }

  //DATABASE CREATION
  initDb() async {
    //VARIABLE PARA RUTA DE LOS ARCHIVOS DE LA APLICACION
    io.Directory appDirectory = await getApplicationDocumentsDirectory();
    print(appDirectory);
    String path = join(appDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute("CREATE TABLE $TABLE ($Id INTEGER PRIMARY KEY, $nombre TEXT,$fecha DATE, $hora TIME, $descripcion TEXT)");

    await db
        .execute("CREATE TABLE $TABLE2 ($Id INTEGER PRIMARY KEY , $nombre TEXT,$fecha DATE, $hora TIME, $descripcion TEXT)");
    await db
        .execute("CREATE TABLE $TABLE3 ($Id INTEGER PRIMARY KEY, $nombre TEXT,$fecha DATE, $hora TIME, $descripcion TEXT)");
    await db
        .execute("CREATE TABLE $TABLE4 ($num INTEGER PRIMARY KEY,$Id INTEGER , $tipo TEXT, $nombre TEXT,$fecha DATE, $hora TIME, $descripcion TEXT)");

  }

  //EQUIVALENTE A SELECT
  Future<List<Recordatorio>> getRecordatorios() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [Id,nombre,fecha,hora,descripcion]);
    List<Recordatorio> recordatorios = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        recordatorios.add(Recordatorio.fromMap(maps[i]));
      }
    }
    return recordatorios;
  }

  Future<List<Recordatorio>> getRecordatorios2() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE2, columns: [Id,nombre,fecha,hora,descripcion]);
    List<Recordatorio> recordatorios = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        recordatorios.add(Recordatorio.fromMap(maps[i]));
      }
    }
    return recordatorios;
  }

  Future<List<Recordatorio>> getRecordatorios3() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE3, columns: [Id,nombre,fecha,hora,descripcion]);
    List<Recordatorio> recordatorios = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        recordatorios.add(Recordatorio.fromMap(maps[i]));
      }
    }
    return recordatorios;
  }

  Future<List<completados>> getRecordatorios4() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE4, columns: [num,Id,tipo,nombre,fecha,hora,descripcion]);
    List<completados> recordatorios = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        recordatorios.add(completados.fromMap(maps[i]));
      }
    }
    return recordatorios;
  }


  Future<List<Map>> decodificar() async{
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [
      Id,
      nombre,
      fecha,
      hora,
      descripcion
    ]);


    return maps;
  }

  Future<List<Map>> decodificar2() async{
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE2, columns: [
      Id,
      nombre,
      fecha,
      hora,
      descripcion
    ]);


    return maps;
  }

  Future<List<Map>> decodificar3() async{
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE3, columns: [
      Id,
      nombre,
      fecha,
      hora,
      descripcion
    ]);


    return maps;
  }


  //EQUIVALENTE A SAVE O INSERT
  Future<Recordatorio> insert (Recordatorio recordator) async{
    var dbClient = await db;
    recordator.id = await dbClient.insert(TABLE, recordator.toMap());
    return recordator;
  }

  Future<Recordatorio> insert2 (Recordatorio recordator) async{
    var dbClient = await db;
    recordator.id = await dbClient.insert(TABLE2, recordator.toMap());
    return recordator;
  }
  Future<Recordatorio> insert3 (Recordatorio recordator) async{
    var dbClient = await db;
    recordator.id = await dbClient.insert(TABLE3, recordator.toMap());
    return recordator;
  }
  Future<completados> insert4 (completados completado) async{
    var dbClient = await db;
    completado.id = await dbClient.insert(TABLE4, completado.toMap());
    return completado;
  }
  //EQUIVALENTE A DELETE
  Future<int> delete(int id) async{
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$Id = ?', whereArgs: [id]);
  }
  Future<int> delete2(int id) async{
    var dbClient = await db;
    return await dbClient.delete(TABLE2, where: '$Id = ?', whereArgs: [id]);
  }
  Future<int> delete3(int id) async{
    var dbClient = await db;
    return await dbClient.delete(TABLE3, where: '$Id = ?', whereArgs: [id]);
  }
  Future<int> delete4(int num) async{
    var dbClient = await db;
    return await dbClient.delete(TABLE4, where: '$num = ?', whereArgs: [num]);
  }

  //EQUIVALENTE A UPDATE
  Future<int> update(Recordatorio recordator) async{
    var dbClient = await db;
    return await dbClient.update(TABLE, recordator.toMap(),
        where: '$Id = ?', whereArgs: [recordator.id]);
  }
  Future<int> update2(Recordatorio recordator) async{
    var dbClient = await db;
    return await dbClient.update(TABLE2, recordator.toMap(),
        where: '$Id = ?', whereArgs: [recordator.id]);
  }
  Future<int> update3(Recordatorio recordator) async{
    var dbClient = await db;
    return await dbClient.update(TABLE3, recordator.toMap(),
        where: '$Id = ?', whereArgs: [recordator.id]);
  }

  //CLOSE DATABASE
  Future closedb()async{
    var dbClient = await db;
    dbClient.close();
  }
}



//  Future<List<Recordatorio>>decodificaraMap(String inicial) async {
//    print("entrando a decodificar a map");
//    final bd = await db;
//    List maps = await bd.rawQuery("SELECT * FROM $TABLE WHERE $nombre LIKE '$inicial%'");
//    List<Recordatorio> recordatorios = [];
//    print(maps);
//    print(maps.length);
//    if (maps.length > 0) {
//      for (int i = 0; i < maps.length; i++) {
//        recordatorios.add(Recordatorio.fromMap(maps[i]));
//      }
//
//      print(maps[0]);
//
//  }
//    return recordatorios;
//  }


