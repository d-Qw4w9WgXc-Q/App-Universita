import 'package:flutter/material.dart';
import '../models/viaggio.dart';
import '../models/tappa.dart';
import '../models/attivita.dart';
import '../models/checklist.dart';
import '../models/spesa.dart';
import '../services/storage_service.dart';

class TravelProvider with ChangeNotifier {
        final StorageService _storageService = StorageService();

        List<Viaggio> _viaggi = [];
        List<Tappa> _tappe = [];
        List<Attivita> _attivita = [];
        List<ChecklistItem> _checklist = [];
        List<Spesa> _spese = [];
        bool _isLoading = true;

        List<Viaggio> get viaggi => _viaggi;
        List<Tappa> get tappe => _tappe;
        List<Attivita> get attivita => _attivita;
        List<ChecklistItem> get checklist => _checklist;
        List<Spesa> get spese => _spese;
        bool get isLoading => _isLoading;

        TravelProvider() {
                loadData();
        }

        Future<void> loadData() async {
                _isLoading = true;
                notifyListeners();
                try {
                        final data = await _storageService.loadAll();
                        _viaggi = data['viaggi'] ?? [];
                        _tappe = data['tappe'] ?? [];
                        _attivita = data['attivita'] ?? [];
                        _checklist = data['checklist'] ?? [];
                        _spese = data['spese'] ?? [];
                } catch (e) {
                        debugPrint('Errore caricamento locale: $e');
                } finally {
                        _isLoading = false;
                        notifyListeners();
                }
        }

        Future<void> _saveData() async {
                await _storageService.saveAll(
                        viaggi: _viaggi,
                        tappe: _tappe,
                        attivita: _attivita,
                        checklist: _checklist,
                        spese: _spese,
                );
                notifyListeners();
        }

        // ==========================================
        // OPERAZIONI VIAGGI (CRUD)
        // ==========================================

        Future<void> addViaggio(Viaggio viaggio) async {
                _viaggi.add(viaggio);
                await _saveData();
        }

        Future<void> updateViaggio(Viaggio viaggio) async {
                final idx = _viaggi.indexWhere((v) => v.id == viaggio.id);
                if (idx != -1) {
                        _viaggi[idx] = viaggio;
                        await _saveData();
                }
        }

        Future<void> deleteViaggio(String viaggioId) async {
                _viaggi.removeWhere((v) => v.id == viaggioId);
                _tappe.removeWhere((t) => t.viaggioId == viaggioId);
                _attivita.removeWhere((a) => a.viaggioId == viaggioId);
                _checklist.removeWhere((c) => c.viaggioId == viaggioId);
                _spese.removeWhere((s) => s.viaggioId == viaggioId);
                await _saveData();
        }

        // ==========================================
        // OPERAZIONI TAPPE (CRUD)
        // ==========================================

        List<Tappa> getTappeByViaggio(String viaggioId) {
                final list = _tappe.where((t) => t.viaggioId == viaggioId).toList();
                list.sort((a, b) => a.ordine.compareTo(b.ordine));
                return list;
        }

        Future<void> addTappa(Tappa tappa) async {
                _tappe.add(tappa);
                await _saveData();
        }

        Future<void> updateTappa(Tappa tappa) async {
                final idx = _tappe.indexWhere((t) => t.id == tappa.id);
                if (idx != -1) {
                        _tappe[idx] = tappa;
                        await _saveData();
                }
        }

        Future<void> deleteTappa(String tappaId) async {
                _tappe.removeWhere((t) => t.id == tappaId);
                for (var a in _attivita) {
                        if (a.tappaId == tappaId) {
                                a.tappaId = null;
                        }
                }
                await _saveData();
        }

        // ==========================================
        // OPERAZIONI ATTIVITÀ (CRUD)
        // ==========================================

        List<Attivita> getAttivitaByTappa(String tappaId) {
                final list = _attivita.where((a) => a.tappaId == tappaId).toList();
                list.sort((a, b) => a.dataOra.compareTo(b.dataOra));
                return list;
        }

        List<Attivita> getAttivitaByViaggio(String viaggioId) {
                final list = _attivita.where((a) => a.viaggioId == viaggioId).toList();
                list.sort((a, b) => a.dataOra.compareTo(b.dataOra));
                return list;
        }

        Future<void> addAttivita(Attivita att) async {
                _attivita.add(att);
                await _saveData();
        }

        Future<void> updateAttivita(Attivita att) async {
                final idx = _attivita.indexWhere((a) => a.id == att.id);
                if (idx != -1) {
                        _attivita[idx] = att;
                        await _saveData();
                }
        }

        Future<void> deleteAttivita(String attId) async {
                _attivita.removeWhere((a) => a.id == attId);
                for (var s in _spese) {
                        if (s.attivitaId == attId) {
                                s.attivitaId = null;
                        }
                }
                await _saveData();
        }

        // ==========================================
        // OPERAZIONI CHECKLIST (CRUD)
        // ==========================================

        List<ChecklistItem> getChecklistByViaggio(String viaggioId) {
                return _checklist.where((c) => c.viaggioId == viaggioId).toList();
        }

        Future<void> addChecklistItem(ChecklistItem item) async {
                _checklist.add(item);
                await _saveData();
        }

        Future<void> updateChecklistItem(ChecklistItem item) async {
                final idx = _checklist.indexWhere((c) => c.id == item.id);
                if (idx != -1) {
                        _checklist[idx] = item;
                        await _saveData();
                }
        }

        Future<void> toggleChecklistItem(String itemId) async {
                final idx = _checklist.indexWhere((c) => c.id == itemId);
                if (idx != -1) {
                        _checklist[idx] = _checklist[idx].copyWith(
                                completato: !_checklist[idx].completato
                        );
                        await _saveData();
                }
        }

        Future<void> deleteChecklistItem(String itemId) async {
                _checklist.removeWhere((c) => c.id == itemId);
                await _saveData();
        }

        // ==========================================
        // OPERAZIONI SPESE (CRUD)
        // ==========================================

        List<Spesa> getSpeseByViaggio(String viaggioId) {
                return _spese.where((s) => s.viaggioId == viaggioId).toList();
        }

        Future<void> addSpesa(Spesa spesa) async {
                _spese.add(spesa);
                await _saveData();
        }

        Future<void> updateSpesa(Spesa spesa) async {
                final idx = _spese.indexWhere((s) => s.id == spesa.id);
                if (idx != -1) {
                        _spese[idx] = spesa;
                        await _saveData();
                }
        }

        Future<void> deleteSpesa(String spesaId) async {
                _spese.removeWhere((s) => s.id == spesaId);
                await _saveData();
        }

        // ==========================================
        // ADVANCED FEATURE 1: DUPLICAZIONE VIAGGIO
        // ==========================================
        // Genera una copia esatta del viaggio slittando le date 
        // e ricalcolando in proporzione l'agenda di tappe e attività.
        Future<void> duplicaViaggio(String viaggioId, String nuovoTitolo, DateTime nuovaDataInizio) async {
                final origViaggio = _viaggi.firstWhere((v) => v.id == viaggioId);
                final offset = nuovaDataInizio.difference(origViaggio.dataInizio);
                final durata = origViaggio.dataFine.difference(origViaggio.dataInizio);
                final nuovaDataFine = nuovaDataInizio.add(durata);

                final nuovoViaggioId = 'v_${DateTime.now().millisecondsSinceEpoch}';

                final copiaViaggio = Viaggio(
                        id: nuovoViaggioId,
                        titolo: nuovoTitolo,
                        destinazione: origViaggio.destinazione,
                        dataInizio: nuovaDataInizio,
                        dataFine: nuovaDataFine,
                        descrizione: origViaggio.descrizione,
                        stato: 'Futuro',
                        budget: origViaggio.budget,
                        partecipanti: List<String>.from(origViaggio.partecipanti),
                        infoGenerali: origViaggio.infoGenerali,
                );

                _viaggi.add(copiaViaggio);

                // Duplicazione delle tappe mantendo l'ordine
                final origTappe = getTappeByViaggio(viaggioId);
                final Map<String, String> mappaTappeId = {};
                for (var t in origTappe) {
                        final nuovoTappaId = 't_${DateTime.now().microsecondsSinceEpoch}_${t.id.hashCode}';
                        mappaTappeId[t.id] = nuovoTappaId;

                        final copiaTappa = Tappa(
                                id: nuovoTappaId,
                                viaggioId: nuovoViaggioId,
                                titolo: t.titolo,
                                data: t.data.add(offset),
                                localita: t.localita,
                                descrizione: t.descrizione,
                                ordine: t.ordine,
                                note: t.note,
                        );
                        _tappe.add(copiaTappa);
                }

                // Duplicazione delle attività collegate
                final origAttivita = getAttivitaByViaggio(viaggioId);
                for (var a in origAttivita) {
                        final nuovoAttId = 'a_${DateTime.now().microsecondsSinceEpoch}_${a.id.hashCode}';
                        final nuovoTappaId = a.tappaId != null ? mappaTappeId[a.tappaId] : null;

                        final copiaAtt = Attivita(
                                id: nuovoAttId,
                                viaggioId: nuovoViaggioId,
                                tappaId: nuovoTappaId,
                                titolo: a.titolo,
                                descrizione: a.descrizione,
                                dataOra: a.dataOra.add(offset),
                                luogo: a.luogo,
                                categoria: a.categoria,
                                costoPrevisto: a.costoPrevisto,
                                stato: 'Da Svolgere',
                                note: a.note,
                        );
                        _attivita.add(copiaAtt);
                }

                // Duplicazione checklist (ripristinata allo stato iniziale "da fare")
                final origCheck = getChecklistByViaggio(viaggioId);
                for (var c in origCheck) {
                        final nuovoCheckId = 'c_${DateTime.now().microsecondsSinceEpoch}_${c.id.hashCode}';
                        final copiaCheck = ChecklistItem(
                                id: nuovoCheckId,
                                viaggioId: nuovoViaggioId,
                                titolo: c.titolo,
                                completato: false,
                                categoria: c.categoria,
                        );
                        _checklist.add(copiaCheck);
                }

                await _saveData();
        }

        // ==========================================
        // ADVANCED FEATURE 2: GENERAZIONE AUTOMATICA PACKING LIST
        // ==========================================
        // Costruisce una lista oggetti da portare basata sulla tipologia del viaggio.
        Future<void> generaPackingListAutomatica(String viaggioId, String categoria) async {
                final List<Map<String, String>> template = [];

                if (categoria == 'Mare') {
                        template.addAll([
                                {'titolo': 'Costume da bagno', 'cat': 'Valigia'},
                                {'titolo': 'Crema solare protettiva', 'cat': 'Valigia'},
                                {'titolo': 'Telo mare e infradito', 'cat': 'Valigia'},
                                {'titolo': 'Occhiali da sole e cappello', 'cat': 'Valigia'},
                        ]);
                } else if (categoria == 'Montagna') {
                        template.addAll([
                                {'titolo': 'Scarponcini da trekking', 'cat': 'Valigia'},
                                {'titolo': 'Giacca a vento ed impermeabile', 'cat': 'Valigia'},
                                {'titolo': 'Zaino da escursione', 'cat': 'Valigia'},
                                {'titolo': 'Borraccia d\'acqua', 'cat': 'Valigia'},
                        ]);
                } else if (categoria == 'Città d\'Arte') {
                        template.addAll([
                                {'titolo': 'Scarpe comode per camminare', 'cat': 'Valigia'},
                                {'titolo': 'Powerbank per smartphone', 'cat': 'Valigia'},
                                {'titolo': 'Guida turistica della città', 'cat': 'Documenti'},
                                {'titolo': 'Ombrello tascabile', 'cat': 'Valigia'},
                        ]);
                } else if (categoria == 'Lavoro') {
                        template.addAll([
                                {'titolo': 'Laptop e caricabatterie', 'cat': 'Valigia'},
                                {'titolo': 'Abbigliamento formale', 'cat': 'Valigia'},
                                {'titolo': 'Biglietti da visita', 'cat': 'Documenti'},
                                {'titolo': 'Quaderno per appunti', 'cat': 'Valigia'},
                        ]);
                }

                // Generali indispensabili sempre inseriti
                template.addAll([
                        {'titolo': 'Documento d\'identità / Passaporto', 'cat': 'Documenti'},
                        {'titolo': 'Tessera sanitaria', 'cat': 'Documenti'},
                        {'titolo': 'Spazzolino e dentifricio', 'cat': 'Valigia'},
                        {'titolo': 'Caricatore del telefono', 'cat': 'Valigia'},
                ]);

                for (var item in template) {
                        final id = 'auto_${DateTime.now().microsecondsSinceEpoch}_${item['titolo'].hashCode}';
                        _checklist.add(ChecklistItem(
                                id: id,
                                viaggioId: viaggioId,
                                titolo: item['titolo']!,
                                completato: false,
                                categoria: item['cat']!,
                        ));
                }

                await _saveData();
        }

        // ==========================================
        // STATISTICHE INTEGRATE
        // ==========================================

        Map<String, dynamic> calcolaStatisticheViaggio(String viaggioId) {
                final speseViaggio = getSpeseByViaggio(viaggioId);
                final attivitaViaggio = getAttivitaByViaggio(viaggioId);
                final checkViaggio = getChecklistByViaggio(viaggioId);

                double previstaTot = 0.0;
                double effettivaTot = 0.0;
                Map<String, double> perCategoria = {};

                for (var s in speseViaggio) {
                        if (s.tipo == 'Prevista') {
                                previstaTot += s.importo;
                        } else {
                                effettivaTot += s.importo;
                                perCategoria[s.categoria] = (perCategoria[s.categoria] ?? 0.0) + s.importo;
                        }
                }

                int attFatte = attivitaViaggio.where((a) => a.stato == 'Completato').length;
                int checkFatte = checkViaggio.where((c) => c.completato).length;

                return {
                        'previstaTot': previstaTot,
                        'effettivaTot': effettivaTot,
                        'perCategoria': perCategoria,
                        'attFatte': attFatte,
                        'attTot': attivitaViaggio.length,
                        'checkFatte': checkFatte,
                        'checkTot': checkViaggio.length,
                };
        }

        Map<String, int> calcolaRiepilogoGenerale() {
                return {
                        'totale': _viaggi.length,
                        'futuri': _viaggi.where((v) => v.stato == 'Futuro').length,
                        'inCorso': _viaggi.where((v) => v.stato == 'In Corso').length,
                        'completati': _viaggi.where((v) => v.stato == 'Completato').length,
                        'archiviati': _viaggi.where((v) => v.stato == 'Archiviato').length,
                };
        }
}
