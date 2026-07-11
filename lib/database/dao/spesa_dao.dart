import '../../models/spesa.dart';
import '../database_helper.dart';
import '../tables/spesa_table.dart';
import 'package:sqflite/sqflite.dart';


class SpesaDao {

        Future<int> insert(Spesa spesa) async {
                final db = await DatabaseHelper.instance.database;
                return db.insert(SpesaTable.tableName, spesa.toMap());
        }

        Future<List<Spesa>> getAll() async {
                final db = await DatabaseHelper.instance.database;
                final result = await db.query(SpesaTable.tableName);
                return result.map((map) => Spesa.fromMap(map)).toList();
        }

        Future<List<Spesa>> getByAttivita(int attivitaId) async{
                final db = await DatabaseHelper.instance.database;
                final result = await db.rawQuery(
                        '''
                        select s.*
                        from spese s
                        join attivita a
                        on a.id = s.attivita_id
                        where a.id = ?
                        '''
                        ,[attivitaId]
                );
                return result.map((map) => Spesa.fromMap(map)).toList();
        }

        Future<int> countByAttivita(int attivitaId) async {
                final db = await DatabaseHelper.instance.database;
                final result = await db.rawQuery(
                        '''
                        'SELECT COUNT(*)
                        FROM spesa WHERE attivita_id = ?'
                        ''',
                        [attivitaId]
                );
                return Sqflite.firstIntValue(result) ?? 0;
        }

        Future<int> update(Spesa spesa) async {
                final db = await DatabaseHelper.instance.database;
                return db.update(SpesaTable.tableName, spesa.toMap(), where: 'id = ?', whereArgs: [spesa.id]);
        }

        Future<int> delete(int id) async {
                final db = await DatabaseHelper.instance.database;
                return db.delete(SpesaTable.tableName, where: 'id = ?', whereArgs: [id]);
        }

}