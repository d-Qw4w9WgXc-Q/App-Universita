import 'package:sqflite/sqflite.dart';

class AttivitaTable {
        static const String tableName = 'attivita';

        static Future<void> create(Database db) async {
                await db.execute('''
                        create table $tableName(
                                id integer primary key,
                                viaggio_id integer not null,
                                tappa_id integer not null,
                                titolo text not null,
                                descrizione text,
                                inizio text,
                                fine text,
                                luogo text,
                                categoria text,
                                costo integer,
                                stato integer not null default 0,
                                foreign key (viaggio_id, tappa_id) references tappa(viaggio_id, id)
                        );
                ''');
        }
}