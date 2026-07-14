import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'tables/attivita_table.dart';
import 'tables/partecipante_table.dart';
import 'tables/partecipazione_table.dart';
import 'tables/spesa_table.dart';
import 'tables/tappa_table.dart';
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
        return openDatabase(
                path,version: 1,
                onConfigure: _onConfigure,
                onCreate: _onCreate,
                onUpgrade: _onUpgrade
                );
        }

        Future<void> _onConfigure(Database db) async {
                await db.execute('PRAGMA foreign_keys = ON');
        }

        Future<void> _onCreate(Database db, int version) async {
                await ViaggioTable.create(db);

                await TappaTable.create(db);
                await AttivitaTable.create(db);
                await SpesaTable.create(db);

                await PartecipanteTable.create(db);
                await PartecipazioneTable.create(db);
        }

        Future<void> _onUpgrade(
                Database db,
                int oldVersion,
                int newVersion,
                ) async {
                        //codice per eventuali upgrade del database
                }

        Future<void> close() async {
                final db = await database;
                await db.close();
        }
}