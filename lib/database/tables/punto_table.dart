import 'package:sqflite/sqflite.dart';

class PuntoTable {
        static const String tableName = 'punti';

        static Future<void> create(Database db) async {
                await db.execute('''
                        create table $tableName(
                                id integer primary key,
                                viaggio_id integer not null,
                                descrizione text,
                                stato integer not null default 0,
                                foreign key (viaggio_id) references viaggio(id),
                        );
                ''');
        }
}