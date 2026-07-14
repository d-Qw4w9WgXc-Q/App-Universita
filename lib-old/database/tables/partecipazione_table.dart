import 'package:sqflite/sqflite.dart';

class PartecipazioneTable {
        static const String tableName = 'partecipazioni';

        static Future<void> create(Database db) async {
                await db.execute('''
                        create table $tableName(
                                id integer primary key,
                                partecipante_id integer not null,
                                viaggio_id integer not null,
                                foreign key (partecipante_id) references partecipante(id),
                                foreign key (viaggio_id) references viaggio(id)
                        );
                ''');
        }
}