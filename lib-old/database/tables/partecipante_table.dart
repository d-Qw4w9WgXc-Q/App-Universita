import 'package:sqflite/sqflite.dart';

class PartecipanteTable {
        static const String tableName = 'partecipanti';

        static Future<void> create(Database db) async {
                await db.execute('''
                        create table $tableName(
                                id integer primary key,
                                nome text not null,
                                cognome text
                        );
                ''');
        }
}