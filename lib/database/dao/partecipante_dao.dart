import '../../models/partecipante.dart';
import '../database_helper.dart';
import '../tables/partecipante_table.dart';

class ViaggioDao {

        Future<int> insert(Partecipante partecipante) async {
                final db = await DatabaseHelper.instance.database;
                return db.insert(PartecipanteTable.tableName, partecipante.toMap(),);
        }

        Future<List<Partecipante>> getAll() async {
                final db = await DatabaseHelper.instance.database;
                final result = await db.query(PartecipanteTable.tableName,);
                return result.map((map) => Partecipante.fromMap(map)).toList();
        }

        Future<int> update(Partecipante partecipante) async {
                final db = await DatabaseHelper.instance.database;
                return db.update(PartecipanteTable.tableName, partecipante.toMap(), where: 'id = ?', whereArgs: [partecipante.id],);
        }

        Future<int> delete(int id) async {
                final db = await DatabaseHelper.instance.database;
                return db.delete(PartecipanteTable.tableName, where: 'id = ?', whereArgs: [id],);
        }

}