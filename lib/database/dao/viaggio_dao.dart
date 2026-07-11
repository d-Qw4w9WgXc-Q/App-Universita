import '../../models/viaggio.dart';
import '../database_helper.dart';
import '../tables/viaggio_table.dart';

class ViaggioDao {

        Future<int> insert(Viaggio viaggio) async {
                final db = await DatabaseHelper.instance.database;
                return db.insert(ViaggioTable.tableName, viaggio.toMap());
        }

        Future<List<Viaggio>> getAll() async {
                final db = await DatabaseHelper.instance.database;
                final result = await db.query(ViaggioTable.tableName);
                return result.map((map) => Viaggio.fromMap(map)).toList();
        }

        Future<List<Viaggio>> getByPartecipante(int partecipanteId) async{
                final db = await DatabaseHelper.instance.database;
                final result = await db.rawQuery(
                        '''
                        select v.*
                        from viaggi v
                        join partecipazioni p
                        on v.id = p.viaggio_id
                        where p.partecipante_id = ?
                        '''
                        ,[partecipanteId]
                );
                return result.map((map) => Viaggio.fromMap(map)).toList();
        }

        Future<int> update(Viaggio viaggio) async {
                final db = await DatabaseHelper.instance.database;
                return db.update(ViaggioTable.tableName, viaggio.toMap(), where: 'id = ?', whereArgs: [viaggio.id]);
        }

        Future<int> delete(int id) async {
                final db = await DatabaseHelper.instance.database;
                return db.delete(ViaggioTable.tableName, where: 'id = ?', whereArgs: [id]);
        }

}