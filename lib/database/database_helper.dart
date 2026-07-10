import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'tables/viaggio_table.dart';

class DatabaseHelper {
        DatabaseHelper._();

        static final DatabaseHelper instance = DatabaseHelper._();

        Database? _database;

        Future<Database> get database async {
                if (_database != null) {
                return _database!;
                }
                _database = await _initDatabase();
                return _database!;
        }

        Future<Database> _initDatabase() async {
        final databasePath = await getDatabasesPath();
        final path = join(databasePath, 'travel.db');
        return openDatabase(path,version: 1, onConfigure: (db) async {}, onCreate: _onCreate,);
        }

        Future<void> _onCreate(Database db, int version) async {
                await ViaggioTable.create(db);
        }

        Future<void> close() async {
                final db = await database;
                await db.close();
        }
}