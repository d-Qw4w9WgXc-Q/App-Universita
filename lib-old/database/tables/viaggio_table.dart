import 'package:sqflite/sqflite.dart';

class ViaggioTable {
        static const String tableName = 'viaggi';

        static Future<void> create(Database db) async {
                await db.execute('''
                        create table $tableName(
                        id integer primary key,
                        titolo text,
                        destinazione text,
                        inizio text,
                        fine text,
                        descrizione text,
                        stato integer not null default 0,
                        budget real
                        );
                ''');
        }
}