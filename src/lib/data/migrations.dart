import '../data/data.dart';

class SqlMigrationScripts {
  static String createExpressionsTable() {
    return 'CREATE TABLE ${DatabaseConfiguration.expressionsTableName}(id TEXT PRIMARY KEY, name TEXT, formula TEXT, variables TEXT)';
  }
}
