import '../../models/spesa.dart';
import '../database_helper.dart';
import '../tables/spesa_table.dart';

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

        Future<int> update(Spesa spesa) async {
                final db = await DatabaseHelper.instance.database;
                return db.update(SpesaTable.tableName, spesa.toMap(), where: 'id = ?', whereArgs: [spesa.id]);
        }

        Future<int> delete(int id) async {
                final db = await DatabaseHelper.instance.database;
                return db.delete(SpesaTable.tableName, where: 'id = ?', whereArgs: [id]);
        }

}