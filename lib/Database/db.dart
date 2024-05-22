import 'dart:developer';
import 'dart:io';
import 'package:cropsecure_application/Database/sqlquery.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:secufarmsuveyor/config/table_name.dart';
// import 'package:secufarmsuveyor/database/sql_query.dart';
// import 'package:secufarmsuveyor/msg/msg.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class DB {
  int version = 1;
  Database? db;
  static final DB inst = DB();

  Future<void> openDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'cropsecure.db');
    db = await openDatabase(path, version: version);
    log('DB', name: '${directory.path}/cropsecure.db');
    //await dropTable(TableName.cropScheActivity);
    SqlQuery.inst.onCreateTable();
  }

  /*CREATE TABLE*/
  Future createTable(String sqlQuery) async {
    try {
      await db!.execute(sqlQuery);
    } catch (ex) {
      log('DB/createTable', name: '$ex');
      rethrow;
    }
  }

  /*BATCH CREATE TABLE*/
  Future<void> batchCreateTable(List<String> sqlList) async {
    try {
      await db!.transaction((txn) async {
        var batch = txn.batch();
        for (String sql in sqlList) {
          batch.execute("CREATE TABLE IF NOT EXISTS $sql");
        }
        await batch.commit();
        log('DB/batchCreateTable', name: 'Successfully Create All Table');
      });
    } catch (ex) {
      log('DB/batchCreateTable', name: '$ex');
      rethrow;
    }
  }

  /*INSERT DATA*/
  Future insertData(String sqlQuery, List list) async {
    try {
      await db!.rawInsert(sqlQuery, list);
    } catch (ex) {
      log("DB/InsertData", name: '$ex');
      rethrow;
    }
  }

  Future insert(String tblName, dynamic mdl) async {
    try {
      await db!.insert(tblName, mdl.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      log('DB/Insert', name: 'Data Inserted: $tblName');
    } catch (ex) {
      log("DB/Insert", name: '$ex');
      rethrow;
    }
  }

  /*BATCH INSERT*/
  Future<void> batchInsert(String tblName, List<dynamic> mdlList) async {
    try {
      await db!.transaction((txn) async {
        var batch = txn.batch();
        for (var record in mdlList) {
          batch.insert(tblName, record.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
        await batch.commit();
      });
      log('DB/batchInsert', name: 'Data Inserted: $tblName');
    } catch (ex) {
      log('DB/batchInsert', name: '$ex');
      rethrow;
    }
  }

  /*UPDATE DATA*/
  Future updateData(String sqlQuery, List list) async {
    try {
      await db!.rawUpdate(sqlQuery, list);
    } catch (ex) {
      log('DB/updateData', name: '$ex');
      rethrow;
    }
  }

  /*UPDATE*/
  Future<void> update(
      {required String tblName,
      required dynamic mdl,
      String? where,
      List? whereArgs}) async {
    try {
      await db!
          .update(tblName, mdl.toMap(), where: where, whereArgs: whereArgs);
    } catch (ex) {
      log('DB/update', name: '$ex');
      rethrow;
    }
  }

  /*SELECT*/
  Future<List> select(String sqlQuery, List where) async {
    try {
      return await db!.rawQuery(sqlQuery, where);
    } catch (ex) {
      log('Db/Select', name: '$ex');
      return [];
    }
  }

  Future<List> selectTblName(String tblName) async {
    try {
      return await db!.rawQuery('SELECT * FROM $tblName');
    } catch (ex) {
      log('Db/selectTblName', name: '$ex');
      return [];
    }
  }

  /*DELETE*/
  Future delete(String tblName, String? where, List? whereArgs) async {
    try {
      await db!.delete(tblName, where: where, whereArgs: whereArgs);
      log('DB/Delete', name: '$tblName where:$where whereArgs:$whereArgs');
    } catch (ex) {
      log('DB/Delete', name: '$ex');
      rethrow;
    }
  }

  /*DROP TABLE*/
  Future dropTable(String tblName) async {
    try {
      await db!.rawDelete('DROP TABLE IF EXISTS $tblName');
    } catch (ex) {
      log('dropTable', name: '$ex');
      rethrow;
    }
  }

  /*DOES TABLE EXISTS*/
  Future<bool> doesTableExist(String tableName) async {
    bool isTable = false;
    try {
      final result = await db!.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'");
      isTable = result.isNotEmpty;
    } catch (ex) {
      log('DB/doesTableExist', name: '$ex');
    }

    return isTable;
  }

  /*DOES TABLE HAVE DATA*/
  Future<bool> doesTableHaveData(String tableName) async {
    try {
      final result = await db!.rawQuery('SELECT COUNT(*) FROM $tableName;');
      final count = Sqflite.firstIntValue(result);
      return count! > 0;
    } catch (ex) {
      log("DB/doesTableHaveData", name: '$ex');
      return false;
    }
  }

  Future<void> batchDeleteAllData(List<String> tableList) async {
    try {
      await db!.transaction((txn) async {
        var batch = txn.batch();
        for (String tableName in tableList) {
          batch.rawDelete("DELETE FROM $tableName");
        }
        await batch.commit();
        log('db/batchDeleteAllData',
            name: 'Successfully Delete All Data Table: $tableList');
      });
    } catch (ex) {
      log('db/batchDeleteAllData', name: '$ex');
    }
  }
}
