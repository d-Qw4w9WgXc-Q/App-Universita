import '../../models/punto.dart';
import '../database_helper.dart';
import '../tables/punto_table.dart';
import 'package:sqflite/sqflite.dart';

class PuntoDao {

        Future<int> insert(Punto punto) async {
                final db = await DatabaseHelper.instance.database;
                return db.insert(PuntoTable.tableName, punto.toMap());
        }

        Future<List<Punto>> getAll() async {
                final db = await DatabaseHelper.instance.database;
                final result = await db.query(PuntoTable.tableName);
                return result.map((map) => Punto.fromMap(map)).toList();
        }

        Future<List<Punto>> getByViaggio(int viaggioId) async {
                final db = await DatabaseHelper.instance.database;
                final result = await db.query(
                        PuntoTable.tableName,
                        where: 'viaggio_id = ?',
                        whereArgs: [viaggioId]
                );
                return result.map((map) => Punto.fromMap(map)).toList();
        }

        Future<int> countByViaggio(int viaggioId) async {
                final db = await DatabaseHelper.instance.database;
                final result = await db.rawQuery(
                        '''
                        'SELECT COUNT(*)
                        FROM punti WHERE viaggio_id = ?'
                        ''',
                        [viaggioId]
                );
                return Sqflite.firstIntValue(result) ?? 0;
        }

        Future<int> update(Punto punto) async {
                final db = await DatabaseHelper.instance.database;
                return db.update(PuntoTable.tableName, punto.toMap(), where: 'id = ?', whereArgs: [punto.id]);
        }

        Future<int> delete(int id) async {
                final db = await DatabaseHelper.instance.database;
                return db.delete(PuntoTable.tableName, where: 'id = ?', whereArgs: [id]);
        }

}