import 'package:sqflite/sqflite.dart';

class TappaTable {
        static const String tableName = 'tappe';

        static Future<void> create(Database db) async {
                await db.execute('''
                        create table $tableName(
                                id integer primary key,
                                viaggio_id integer not null,
                                titolo text not null,
                                data text,
                                luogo text,
                                descrizione text,
                                foreign key (viaggio_id) references viaggio(id),
                        );
                ''');
        }
}