import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/viaggio.dart';
import '../models/tappa.dart';
import '../models/attivita.dart';
import '../models/checklist.dart';
import '../models/spesa.dart';

class StorageService {
        static const String _keyViaggi = 'offline_travel_viaggi';
        static const String _keyTappe = 'offline_travel_tappe';
        static const String _keyAttivita = 'offline_travel_attivita';
        static const String _keyChecklist = 'offline_travel_checklist';
        static const String _keySpese = 'offline_travel_spese';

        Future<void> saveAll({
                required List<Viaggio> viaggi,
                required List<Tappa> tappe,
                required List<Attivita> attivita,
                required List<ChecklistItem> checklist,
                required List<Spesa> spese,
        }) async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString(_keyViaggi, jsonEncode(viaggi.map((e) => e.toJson()).toList()));
                await prefs.setString(_keyTappe, jsonEncode(tappe.map((e) => e.toJson()).toList()));
                await prefs.setString(_keyAttivita, jsonEncode(attivita.map((e) => e.toJson()).toList()));
                await prefs.setString(_keyChecklist, jsonEncode(checklist.map((e) => e.toJson()).toList()));
                await prefs.setString(_keySpese, jsonEncode(spese.map((e) => e.toJson()).toList()));
        }

        Future<Map<String, dynamic>> loadAll() async {
                final prefs = await SharedPreferences.getInstance();
                final viaggiStr = prefs.getString(_keyViaggi);
                final tappeStr = prefs.getString(_keyTappe);
                final attivitaStr = prefs.getString(_keyAttivita);
                final checklistStr = prefs.getString(_keyChecklist);
                final speseStr = prefs.getString(_keySpese);

                List<Viaggio> viaggi = [];
                List<Tappa> tappe = [];
                List<Attivita> attivita = [];
                List<ChecklistItem> checklist = [];
                List<Spesa> spese = [];

                if (viaggiStr != null) {
                        final List decoded = jsonDecode(viaggiStr);
                        viaggi = decoded.map((e) => Viaggio.fromJson(e)).toList();
                }
                if (tappeStr != null) {
                        final List decoded = jsonDecode(tappeStr);
                        tappe = decoded.map((e) => Tappa.fromJson(e)).toList();
                }
                if (attivitaStr != null) {
                        final List decoded = jsonDecode(attivitaStr);
                        attivita = decoded.map((e) => Attivita.fromJson(e)).toList();
                }
                if (checklistStr != null) {
                        final List decoded = jsonDecode(checklistStr);
                        checklist = decoded.map((e) => ChecklistItem.fromJson(e)).toList();
                }
                if (speseStr != null) {
                        final List decoded = jsonDecode(speseStr);
                        spese = decoded.map((e) => Spesa.fromJson(e)).toList();
                }

                return {
                        'viaggi': viaggi,
                        'tappe': tappe,
                        'attivita': attivita,
                        'checklist': checklist,
                        'spese': spese,
                };
        }
}
