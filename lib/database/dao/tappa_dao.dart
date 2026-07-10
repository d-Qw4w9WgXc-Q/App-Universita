import '../../models/tappa.dart';
import '../database_helper.dart';
import '../tables/tappa_table.dart';

class TappaDao {

        Future<int> insert(Tappa tappa) async {
                final db = await DatabaseHelper.instance.database;
                return db.insert(TappaTable.tableName, tappa.toMap());
        }

        Future<List<Tappa>> getAll() async {
                final db = await DatabaseHelper.instance.database;
                final result = await db.query(TappaTable.tableName);
                return result.map((map) => Tappa.fromMap(map)).toList();
        }

        Future<int> update(Tappa tappa) async {
                final db = await DatabaseHelper.instance.database;
                return db.update(TappaTable.tableName, tappa.toMap(), where: 'id = ?', whereArgs: [tappa.id]);
        }

        Future<int> delete(int id) async {
                final db = await DatabaseHelper.instance.database;
                return db.delete(TappaTable.tableName, where: 'id = ?', whereArgs: [id]);
        }

}