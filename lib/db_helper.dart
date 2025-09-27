import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  DBHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "soil_analyzer.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute("""
          CREATE TABLE tests (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nitrogen REAL NOT NULL,
            phosphorus REAL NOT NULL,
            potassium REAL NOT NULL,
            pH REAL NOT NULL,
            date TEXT NOT NULL,
            recommendation TEXT NOT NULL
          )
        """);
      },
    );
  }

  // Insert test result
  Future<int> insertTest(Map<String, dynamic> data) async {
    final dbClient = await db;
    return await dbClient.insert("tests", data);
  }

  // Get all test results
  Future<List<Map<String, dynamic>>> getTests() async {
    final dbClient = await db;
    return await dbClient.query("tests", orderBy: "date DESC");
  }

  // Delete all tests
  Future<int> clearTests() async {
    final dbClient = await db;
    return await dbClient.delete("tests");
  }
}
