import '../../models/partecipazione.dart';
import '../database_helper.dart';
import '../tables/partecipazione_table.dart';
import 'package:sqflite/sqflite.dart';

class PartecipazioneDao {

        Future<int> insert(Partecipazione partecipazione) async {
                final db = await DatabaseHelper.instance.database;
                return db.insert(PartecipazioneTable.tableName, partecipazione.toMap());
        }

        Future<List<Partecipazione>> getAll() async {
                final db = await DatabaseHelper.instance.database;
                final result = await db.query(PartecipazioneTable.tableName);
                return result.map((map) => Partecipazione.fromMap(map)).toList();
        }

        Future<int> countByViaggio(int viaggioId) async {
                final db = await DatabaseHelper.instance.database;
                final result = await db.rawQuery(
                        '''
                        'SELECT COUNT(*)
                        FROM partecipazioni
                        WHERE viaggio_id = ?'
                        ''',
                        [viaggioId]
                );
                return Sqflite.firstIntValue(result) ?? 0;
        }

        Future<int> update(Partecipazione partecipazione) async {
                final db = await DatabaseHelper.instance.database;
                return db.update(PartecipazioneTable.tableName, partecipazione.toMap(), where: 'id = ?', whereArgs: [partecipazione.id]);
        }

        Future<int> delete(int id) async {
                final db = await DatabaseHelper.instance.database;
                return db.delete(PartecipazioneTable.tableName, where: 'id = ?', whereArgs: [id]);
        }

}