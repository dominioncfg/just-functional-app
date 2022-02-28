import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

import '../data/data.dart';
import '../models/expression.dart';

class ExpressionsRepository {
  static Future<Database> _getExpressionsDatabase() async {
    var expressionsTableSql = SqlMigrationScripts.createExpressionsTable();
    final dbPath = await sql.getDatabasesPath();
    return sql
        .openDatabase(path.join(dbPath, DatabaseConfiguration.databaseFileName),
            onCreate: (db, version) {
      return db.execute(expressionsTableSql);
    }, version: 1);
  }

  Future<void> addOrUpdate(Expression expression) async {
    final db = await ExpressionsRepository._getExpressionsDatabase();
    var variables = expression.variables.join(',');
    final data = {
      'id': expression.id.toString(),
      'name': expression.name,
      'formula': expression.formula,
      'variables': variables,
    };

    db.insert(
      DatabaseConfiguration.expressionsTableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Expression>> getAll() async {
    final db = await ExpressionsRepository._getExpressionsDatabase();
    var rawExpressions =
        await db.query(DatabaseConfiguration.expressionsTableName);
    var expressions = rawExpressions.map((item) {
      var id = item['id'].toString();
      var name = item['name'].toString();
      var formula = item['formula'].toString();
      var variables = item['variables'].toString().split(',');
      return Expression(id, name, formula, variables);
    }).toList();
    return expressions;
  }

  Future<void> deleteById(String id) async {
    final db = await ExpressionsRepository._getExpressionsDatabase();
    await db.delete(DatabaseConfiguration.expressionsTableName,
        where: 'id = ?', whereArgs: [id]);
  }
}
