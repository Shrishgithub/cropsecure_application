import 'package:cropsecure_application/Database/db.dart';

class SqlQuery {
  String Level1LocationTable = 'Level1LocationTable';
  String Level2LocationTable = 'Level2LocationTable';
  String Level3LocationTable = 'Level3LocationTable';

  static SqlQuery inst = SqlQuery();

  Future onCreateTable() async {
    List<String> sqlList = [
      '$Level1LocationTable (SrNo INTEGER PRIMARY KEY,id TEXT,name TEXT)', //TableName.translation is the name of the table
      '$Level2LocationTable (SrNo INTEGER PRIMARY KEY,Level1Id TEXT,Level2Id Text,Level2Name Text)', // district Data List
      '$Level3LocationTable (SrNo INTEGER PRIMARY KEY,Level2Id TEXT,Level3Id Text,Level3Name Text)', // block Data List
    ];
    await DB.inst.batchCreateTable(sqlList);
  }
}
