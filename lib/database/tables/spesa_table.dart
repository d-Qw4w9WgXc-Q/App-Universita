import 'package:sqflite/sqflite.dart';

class SpesaTable {
        static const String tableName = 'spese';

        static Future<void> create(Database db) async {
                await db.execute('''
                        create table $tableName(
                                id integer primary key,
                                titolo text not null,
                                importo integer,
                                categoria text,
                                data text,
                                viaggio_id text not null,
                                tappa_id integer not null,
                                metodo_pagamento text,
                                stato integer not null default 0,
                                foreign key (viaggio_id, tappa_id) references tappa(viaggio_id, id)
                        );
                ''');
        }
}