import '../../models/attivita.dart';
import '../database_helper.dart';
import '../tables/attivita_table.dart';

class AttivitaDao {

        Future<int> insert(Attivita attivita) async {
                final db = await DatabaseHelper.instance.database;
                return db.insert(AttivitaTable.tableName, attivita.toMap(),);
        }

        Future<List<Attivita>> getAll() async {
                final db = await DatabaseHelper.instance.database;
                final result = await db.query(AttivitaTable.tableName,);
                return result.map((map) => Attivita.fromMap(map)).toList();
        }

        Future<int> update(Attivita attivita) async {
                final db = await DatabaseHelper.instance.database;
                return db.update(AttivitaTable.tableName, attivita.toMap(), where: 'id = ?', whereArgs: [attivita.id],);
        }

        Future<int> delete(int id) async {
                final db = await DatabaseHelper.instance.database;
                return db.delete(AttivitaTable.tableName, where: 'id = ?', whereArgs: [id],);
        }

}