import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/viaggio.dart';
import 'models/tappa.dart';
import 'models/attivita.dart';
import 'models/checklist.dart';
import 'models/spesa.dart';
import 'providers/travel_provider.dart';

void main() {
        WidgetsFlutterBinding.ensureInitialized();
        runApp(const TravelOrganizerApp());
}

class TravelOrganizerApp extends StatelessWidget {
        const TravelOrganizerApp({super.key});

        @override
        Widget build(BuildContext context) {
                return ChangeNotifierProvider(
                        create: (_) => TravelProvider(),
                        child: MaterialApp(
                                title: 'Travel Organizer Offline',
                                theme: ThemeData(
                                        useMaterial3: true,
                                        primarySwatch: Colors.teal,
                                        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
                                ),
                                home: const HomeScreen(),
                                debugShowCheckedModeBanner: false,
                        ),
                );
        }
}

class HomeScreen extends StatefulWidget {
        const HomeScreen({super.key});

        @override
        State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
        String _filtroDestinazione = '';
        String _filtroStato = 'Tutti';

        @override
        Widget build(BuildContext context) {
                final provider = Provider.of<TravelProvider>(context);
                final riepilogo = provider.calcolaRiepilogoGenerale();

                // Logica di Ricerca e Filtro Viaggi
                final listaFiltrata = provider.viaggi.where((v) {
                        final matchDest = v.destinazione.toLowerCase().contains(_filtroDestinazione.toLowerCase()) ||
                                          v.titolo.toLowerCase().contains(_filtroDestinazione.toLowerCase());
                        final matchStato = _filtroStato == 'Tutti' || v.stato == _filtroStato;
                        return matchDest && matchStato;
                }).toList();

                return Scaffold(
                        appBar: AppBar(
                                title: const Text('Travel Organizer Offline ✈️'),
                                centerTitle: true,
                                backgroundColor: Colors.teal.shade700,
                                foregroundColor: Colors.white,
                        ),
                        body: provider.isLoading
                                ? const Center(child: CircularProgressIndicator())
                                : Column(
                                        children: [
                                                _buildStatisticheGeneraliCard(riepilogo),
                                                _buildSezioneFiltri(),
                                                Expanded(
                                                        child: listaFiltrata.isEmpty
                                                                ? const Center(child: Text('Nessun viaggio trovato.'))
                                                                : ListView.builder(
                                                                        itemCount: listaFiltrata.length,
                                                                        itemBuilder: (context, index) {
                                                                                final viaggio = listaFiltrata[index];
                                                                                return _buildViaggioCard(context, provider, viaggio);
                                                                        },
                                                                ),
                                                ),
                                        ],
                                ),
                        floatingActionButton: FloatingActionButton(
                                onPressed: () => _mostraDialogFormViaggio(context),
                                child: const Icon(Icons.add),
                        ),
                );
        }

        Widget _buildStatisticheGeneraliCard(Map<String, int> riepilogo) {
                return Card(
                        margin: const EdgeInsets.all(12),
                        elevation: 4,
                        child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                                const Text('Riepilogo Viaggi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                                const SizedBox(height: 8),
                                                Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        children: [
                                                                _buildStatWidget('Totali', riepilogo['totale'] ?? 0, Colors.black),
                                                                _buildStatWidget('Futuri', riepilogo['futuri'] ?? 0, Colors.blue),
                                                                _buildStatWidget('In Corso', riepilogo['inCorso'] ?? 0, Colors.orange),
                                                                _buildStatWidget('Finiti', riepilogo['completati'] ?? 0, Colors.green),
                                                        ],
                                                )
                                        ],
                                ),
                        ),
                );
        }

        Widget _buildStatWidget(String label, int val, Color col) {
                return Column(
                        children: [
                                Text('$val', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: col)),
                                Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                );
        }

        Widget _buildSezioneFiltri() {
                return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Row(
                                children: [
                                        Expanded(
                                                child: TextField(
                                                        decoration: const InputDecoration(
                                                                hintText: 'Cerca per destinazione...',
                                                                prefixIcon: Icon(Icons.search),
                                                                border: OutlineInputBorder(),
                                                                isDense: true,
                                                        ),
                                                        onChanged: (val) {
                                                                setState(() {
                                                                        _filtroDestinazione = val;
                                                                });
                                                        },
                                                ),
                                        ),
                                        const SizedBox(width: 8),
                                        DropdownButton<String>(
                                                value: _filtroStato,
                                                items: <String>['Tutti', 'Futuro', 'In Corso', 'Completato']
                                                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                                        .toList(),
                                                onChanged: (val) {
                                                        setState(() {
                                                                _filtroStato = val ?? 'Tutti';
                                                        });
                                                },
                                        )
                                ],
                        ),
                );
        }

        Widget _buildViaggioCard(BuildContext context, TravelProvider provider, Viaggio viaggio) {
                final dateStr = "${viaggio.dataInizio.day}/${viaggio.dataInizio.month} - ${viaggio.dataFine.day}/${viaggio.dataFine.month}/${viaggio.dataFine.year}";
                return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                                leading: const CircleAvatar(child: Icon(Icons.flight_takeoff)),
                                title: Text(viaggio.titolo, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('${viaggio.destinazione} ($dateStr)\nStato: ${viaggio.stato}'),
                                isThreeLine: true,
                                trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                                IconButton(
                                                        icon: const Icon(Icons.edit, color: Colors.black87),
                                                        tooltip: 'Modifica Viaggio',
                                                        onPressed: () => _mostraDialogFormViaggio(context, edit: viaggio)
                                                ),
                                                IconButton(
                                                        icon: const Icon(Icons.delete, color: Colors.red),
                                                        onPressed: () => provider.deleteViaggio(viaggio.id),
                                                ),
                                        ],
                                ),
                                onTap: () {
                                        Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (_) => TravelDetailScreen(viaggioId: viaggio.id)),
                                        );
                                },
                        ),
                );
        }

        void _mostraDialogFormViaggio(BuildContext context, {Viaggio? edit}) {
                final provider = Provider.of<TravelProvider>(context, listen: false);
                final formKey = GlobalKey<FormState>();
                final titCtrl = TextEditingController(text: edit?.titolo ?? '');
                final destCtrl = TextEditingController(text: edit?.destinazione ?? '');
                final descCtrl = TextEditingController(text: edit?.descrizione ?? '');
                final budgetCtrl = TextEditingController(text: edit?.budget.toString() ?? '0.0');
                final partCtrl = TextEditingController(text: edit?.partecipanti.join(', ') ?? '');
                final infoCtrl = TextEditingController(text: edit?.infoGenerali ?? '');
                String statoSel = edit?.stato ?? 'Futuro';
                DateTime inizio = edit?.dataInizio ?? DateTime.now();
                DateTime fine = edit?.dataFine ?? DateTime.now().add(const Duration(days: 3));

                showDialog(
                        context: context,
                        builder: (ctx) {
                                return StatefulBuilder(builder: (context, setDialogState) {
                                        return AlertDialog(
                                                title: Text(edit == null ? 'Nuovo Viaggio' : 'Modifica Viaggio'),
                                                content: SingleChildScrollView(
                                                        child: Form(
                                                                key: formKey,
                                                                child: Column(
                                                                        children: [
                                                                                TextFormField(
                                                                                        controller: titCtrl,
                                                                                        decoration: const InputDecoration(labelText: 'Titolo'),
                                                                                        validator: (v) => v!.isEmpty ? 'Inserisci titolo' : null,
                                                                                ),
                                                                                TextFormField(
                                                                                        controller: destCtrl,
                                                                                        decoration: const InputDecoration(labelText: 'Destinazione'),
                                                                                        validator: (v) => v!.isEmpty ? 'Inserisci destinazione' : null,
                                                                                ),
                                                                                TextFormField(
                                                                                        controller: descCtrl,
                                                                                        decoration: const InputDecoration(labelText: 'Descrizione'),
                                                                                ),
                                                                                TextFormField(
                                                                                        controller: budgetCtrl,
                                                                                        keyboardType: TextInputType.number,
                                                                                        decoration: const InputDecoration(labelText: 'Budget Economico (€)'),
                                                                                ),
                                                                                TextFormField(
                                                                                        controller: partCtrl,
                                                                                        decoration: const InputDecoration(labelText: 'Partecipanti (separati da virgola)'),
                                                                                ),
                                                                                TextFormField(
                                                                                        controller: infoCtrl,
                                                                                        decoration: const InputDecoration(labelText: 'Info Utili / Emergenze'),
                                                                                ),
                                                                                DropdownButtonFormField<String>(
                                                                                        isExpanded: true,
                                                                                        initialValue: statoSel,
                                                                                        items: <String>['Futuro', 'In Corso', 'Completato']
                                                                                                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                                                                                .toList(),
                                                                                        onChanged: (v) => statoSel = v!,
                                                                                ),
                                                                                const SizedBox(height: 12),
                                                                                Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                                Expanded(
                                                                                                        child: TextButton(
                                                                                                                onPressed: () async {
                                                                                                                        final d = await showDatePicker(
                                                                                                                                context: context,
                                                                                                                                initialDate: inizio,
                                                                                                                                firstDate: DateTime.now(),
                                                                                                                                lastDate: DateTime(2040),
                                                                                                                        );
                                                                                                                        if (d != null) setDialogState(() => inizio = d);
                                                                                                                },
                                                                                                                child: Text("Da: ${inizio.day}/${inizio.month}/${inizio.year}"),
                                                                                                        )
                                                                                                ),
                                                                                                Expanded(
                                                                                                        child: TextButton(
                                                                                                                onPressed: () async {
                                                                                                                        final d = await showDatePicker(
                                                                                                                                context: context,
                                                                                                                                initialDate: fine,
                                                                                                                                firstDate: DateTime.now(),
                                                                                                                                lastDate: DateTime(2040),
                                                                                                                        );
                                                                                                                        if (d != null) setDialogState(() => fine = d);
                                                                                                                },
                                                                                                                child: Text("A: ${fine.day}/${fine.month}/${fine.year}"),
                                                                                                        )
                                                                                                )
                                                                                        ],
                                                                                )
                                                                        ],
                                                                ),
                                                        ),
                                                ),
                                                actions: [
                                                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annulla')),
                                                        ElevatedButton(
                                                                onPressed: () {
                                                                        if (formKey.currentState!.validate()) {
                                                                                final pList = partCtrl.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                                                                                final v = Viaggio(
                                                                                        id: edit?.id ?? 'v_${DateTime.now().millisecondsSinceEpoch}',
                                                                                        titolo: titCtrl.text,
                                                                                        destinazione: destCtrl.text,
                                                                                        dataInizio: inizio,
                                                                                        dataFine: fine,
                                                                                        descrizione: descCtrl.text,
                                                                                        stato: statoSel,
                                                                                        budget: double.tryParse(budgetCtrl.text) ?? 0.0,
                                                                                        partecipanti: pList,
                                                                                        infoGenerali: infoCtrl.text,
                                                                                );
                                                                                if (edit == null) {
                                                                                        provider.addViaggio(v);
                                                                                } else {
                                                                                        provider.updateViaggio(v);
                                                                                }
                                                                                Navigator.pop(ctx);
                                                                        }
                                                                },
                                                                child: const Text('Salva'),
                                                        )
                                                ],
                                        );
                                });
                        },
                );
        }
}

class TravelDetailScreen extends StatelessWidget {
        final String viaggioId;

        const TravelDetailScreen({super.key, required this.viaggioId});

        @override
        Widget build(BuildContext context) {
                final provider = Provider.of<TravelProvider>(context);
                final viaggio = provider.viaggi.firstWhere((v) => v.id == viaggioId);

                return DefaultTabController(
                        length: 5,
                        child: Scaffold(
                                appBar: AppBar(
                                        title: Text(viaggio.titolo),
                                        backgroundColor: Colors.teal.shade600,
                                        foregroundColor: Colors.white,
                                        bottom: const TabBar(
                                                isScrollable: true,
                                                labelColor: Colors.white,
                                                unselectedLabelColor: Colors.white70,
                                                tabs: [
                                                        Tab(icon: Icon(Icons.map), text: 'Tappe'),
                                                        Tab(icon: Icon(Icons.event), text: 'Attività'),
                                                        Tab(icon: Icon(Icons.playlist_add_check), text: 'Checklist'),
                                                        Tab(icon: Icon(Icons.euro), text: 'Spese'),
                                                        Tab(icon: Icon(Icons.info), text: 'Info & Stat'),
                                                ],
                                        ),
                                ),
                                body: TabBarView(
                                        children: [
                                                _TappeTab(viaggioId: viaggioId),
                                                _AttivitaTab(viaggioId: viaggioId),
                                                _ChecklistTab(viaggioId: viaggioId),
                                                _SpeseTab(viaggioId: viaggioId),
                                                _InfoStatTab(viaggioId: viaggioId),
                                        ],
                                ),
                        ),
                );
        }
}

class _TappeTab extends StatelessWidget {
        final String viaggioId;
        const _TappeTab({required this.viaggioId});

        @override
        Widget build(BuildContext context) {
                final provider = Provider.of<TravelProvider>(context);
                final tappe = provider.getTappeByViaggio(viaggioId);

                return Scaffold(
                        body: Column(
                                children: [
                                        Expanded(
                                                child: tappe.isEmpty
                                                        ? const Center(child: Text('Nessuna tappa inserita. Aggiungila ora!'))
                                                        : ListView.builder(
                                                                itemCount: tappe.length,
                                                                itemBuilder: (context, idx) {
                                                                        final t = tappe[idx];
                                                                        final dStr = "${t.data.day}/${t.data.month}/${t.data.year}";
                                                                        final attTappa = provider.getAttivitaByTappa(t.id);

                                                                        return Card(
                                                                                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                                child: ExpansionTile(
                                                                                        title: Text('N. ${t.ordine} - ${t.titolo} (${t.localita})'),
                                                                                        subtitle: Text('Data: $dStr'),
                                                                                        trailing: Row(
                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                children: [
                                                                                                        IconButton(
                                                                                                                icon: const Icon(Icons.edit, size: 18),
                                                                                                                onPressed: () => _mostraDialogTappa(context, provider, edit: t),
                                                                                                        ),
                                                                                                        IconButton(
                                                                                                                icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                                                                                                                onPressed: () => provider.deleteTappa(t.id),
                                                                                                        ),
                                                                                                ],
                                                                                        ),
                                                                                        children: [
                                                                                                Padding(
                                                                                                        padding: const EdgeInsets.all(12),
                                                                                                        child: Column(
                                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                children: [
                                                                                                                        Text('Descrizione: ${t.descrizione}'),
                                                                                                                        if (t.note.isNotEmpty) Text('Note: ${t.note}'),
                                                                                                                        const Divider(),
                                                                                                                        const Text('Attività della Tappa:', style: TextStyle(fontWeight: FontWeight.bold)),
                                                                                                                        if (attTappa.isEmpty)
                                                                                                                                const Text('Nessuna attività programmata per questa tappa.', style: TextStyle(fontStyle: FontStyle.italic))
                                                                                                                        else
                                                                                                                                ...attTappa.map((a) => ListTile(
                                                                                                                                        dense: true,
                                                                                                                                        title: Text(a.titolo),
                                                                                                                                        subtitle: Text('${a.categoria} • ${a.luogo}'),
                                                                                                                                        trailing: Text(a.stato),
                                                                                                                                ))
                                                                                                                ],
                                                                                                        ),
                                                                                                )
                                                                                        ],
                                                                                ),
                                                                        );
                                                                },
                                                        ),
                                        ),
                                ],
                        ),
                        floatingActionButton: FloatingActionButton.small(
                                onPressed: () => _mostraDialogTappa(context, provider),
                                child: const Icon(Icons.add),
                        ),
                );
        }

        void _mostraDialogTappa(BuildContext context, TravelProvider provider, {Tappa? edit}) {
                final formKey = GlobalKey<FormState>();
                final titCtrl = TextEditingController(text: edit?.titolo ?? '');
                final locCtrl = TextEditingController(text: edit?.localita ?? '');
                final descCtrl = TextEditingController(text: edit?.descrizione ?? '');
                final ordCtrl = TextEditingController(text: edit?.ordine.toString() ?? '1');
                final noteCtrl = TextEditingController(text: edit?.note ?? '');
                DateTime data = edit?.data ?? DateTime.now();

                showDialog(
                        context: context,
                        builder: (ctx) {
                                return StatefulBuilder(builder: (context, setDialogState) {
                                        return AlertDialog(
                                                title: Text(edit == null ? 'Aggiungi Tappa' : 'Modifica Tappa'),
                                                content: SingleChildScrollView(
                                                        child: Form(
                                                                key: formKey,
                                                                child: Column(
                                                                        children: [
                                                                                TextFormField(
                                                                                        controller: titCtrl,
                                                                                        decoration: const InputDecoration(labelText: 'Titolo Tappa'),
                                                                                        validator: (v) => v!.isEmpty ? 'Inserisci titolo' : null,
                                                                                ),
                                                                                TextFormField(
                                                                                        controller: locCtrl,
                                                                                        decoration: const InputDecoration(labelText: 'Località / Città'),
                                                                                ),
                                                                                TextFormField(
                                                                                        controller: descCtrl,
                                                                                        decoration: const InputDecoration(labelText: 'Descrizione / Programma'),
                                                                                ),
                                                                                TextFormField(
                                                                                        controller: ordCtrl,
                                                                                        keyboardType: TextInputType.number,
                                                                                        decoration: const InputDecoration(labelText: 'Ordine Itinerario (es. 1, 2)'),
                                                                                ),
                                                                                TextFormField(
                                                                                        controller: noteCtrl,
                                                                                        decoration: const InputDecoration(labelText: 'Note aggiuntive'),
                                                                                ),
                                                                                const SizedBox(height: 12),
                                                                                Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                                const Text('Data Tappa:'),
                                                                                                TextButton(
                                                                                                        onPressed: () async {
                                                                                                                final d = await showDatePicker(
                                                                                                                        context: context,
                                                                                                                        initialDate: data,
                                                                                                                        firstDate: DateTime.now(),
                                                                                                                        lastDate: DateTime(2040),
                                                                                                                );
                                                                                                                if (d != null) setDialogState(() => data = d);
                                                                                                        },
                                                                                                        child: Text("${data.day}/${data.month}/${data.year}"),
                                                                                                )
                                                                                        ],
                                                                                )
                                                                        ],
                                                                ),
                                                        ),
                                                ),
                                                actions: [
                                                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annulla')),
                                                        ElevatedButton(
                                                                onPressed: () {
                                                                        if (formKey.currentState!.validate()) {
                                                                                final t = Tappa(
                                                                                        id: edit?.id ?? 't_${DateTime.now().millisecondsSinceEpoch}',
                                                                                        viaggioId: viaggioId,
                                                                                        titolo: titCtrl.text,
                                                                                        data: data,
                                                                                        localita: locCtrl.text,
                                                                                        descrizione: descCtrl.text,
                                                                                        ordine: int.tryParse(ordCtrl.text) ?? 1,
                                                                                        note: noteCtrl.text,
                                                                                );
                                                                                if (edit == null) {
                                                                                        provider.addTappa(t);
                                                                                } else {
                                                                                        provider.updateTappa(t);
                                                                                }
                                                                                Navigator.pop(ctx);
                                                                        }
                                                                },
                                                                child: const Text('Salva'),
                                                        )
                                                ],
                                        );
                                });
                        },
                );
        }
}

class _AttivitaTab extends StatefulWidget {
        final String viaggioId;
        const _AttivitaTab({required this.viaggioId});

        @override
        State<_AttivitaTab> createState() => _AttivitaTabState();
}

class _AttivitaTabState extends State<_AttivitaTab> {
        String _filtroCat = 'Tutte';

       @override
        Widget build(BuildContext context) {
                final provider = Provider.of<TravelProvider>(context);
                final listaAttivita = provider.getAttivitaByViaggio(widget.viaggioId).where((a) {
                        return _filtroCat == 'Tutte' || a.categoria == _filtroCat;
                }).toList();

                return Scaffold(
                        body: Column(
                                children: [
                                        _buildBarraFiltro(),
                                        Expanded(
                                                child: listaAttivita.isEmpty
                                                        ? const Center(child: Text('Nessuna attività pianificata.'))
                                                        : ListView.builder(
                                                                itemCount: listaAttivita.length,
                                                                itemBuilder: (context, idx) {
                                                                        final a = listaAttivita[idx]; 
                                                                        return Card(
                                                                                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                                child: ListTile(
                                                                                        leading: _buildIconaCategoria(a.categoria),
                                                                                        title: Text(a.titolo, style: const TextStyle(fontWeight: FontWeight.bold)),
                                                                                        subtitle: Text('Luogo: ${a.luogo} • Costo: €${a.costoPrevisto}\nStato: ${a.stato}'),
                                                                                        trailing: Row(
                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                children: [
                                                                                                        IconButton(
                                                                                                                icon: const Icon(Icons.edit),
                                                                                                                onPressed: () => _mostraDialogAttivita(context, provider, edit: a),
                                                                                                        ),
                                                                                                        IconButton(
                                                                                                                icon: const Icon(Icons.delete, color: Colors.red),
                                                                                                                onPressed: () => provider.deleteAttivita(a.id),
                                                                                                        ),
                                                                                                ],
                                                                                        ),
                                                                                ),
                                                                        );
                                                                },
                                                        ),
                                        ),
                                ],
                        ),
                        floatingActionButton: FloatingActionButton.small(
                                onPressed: () => _mostraDialogAttivita(context, provider),
                                child: const Icon(Icons.add),
                        ),
                );
        }

        Widget _buildBarraFiltro() {
                return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                                children: [
                                        const Text('Filtra Categoria: '),
                                        const SizedBox(width: 8),
                                        DropdownButton<String>(
                                                value: _filtroCat,
                                                items: <String>['Tutte', 'Visita', 'Escursione', 'Pasto', 'Spostamento', 'Evento', 'Altro']
                                                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                                        .toList(),
                                                onChanged: (v) {
                                                        setState(() {
                                                                _filtroCat = v ?? 'Tutte';
                                                        });
                                                },
                                        )
                                ],
                        ),
                );
        }

        Widget _buildIconaCategoria(String cat) {
                switch (cat) {
                        case 'Pasto': return const Icon(Icons.restaurant, color: Colors.orange);
                        case 'Spostamento': return const Icon(Icons.directions_car, color: Colors.blue);
                        case 'Visita': return const Icon(Icons.museum, color: Colors.purple);
                        case 'Escursione': return const Icon(Icons.terrain, color: Colors.green);
                        case 'Evento': return const Icon(Icons.theater_comedy, color: Colors.red);
                        default: return const Icon(Icons.local_play, color: Colors.teal);
                }
        }

        void _mostraDialogAttivita(BuildContext context, TravelProvider provider, {Attivita? edit}) {
                final formKey = GlobalKey<FormState>();
                final titCtrl = TextEditingController(text: edit?.titolo ?? '');
                final descCtrl = TextEditingController(text: edit?.descrizione ?? '');
                final luogoCtrl = TextEditingController(text: edit?.luogo ?? '');
                final costoCtrl = TextEditingController(text: edit?.costoPrevisto.toString() ?? '0.0');
                final noteCtrl = TextEditingController(text: edit?.note ?? '');
                String catSel = edit?.categoria ?? 'Visita';
                String statoSel = edit?.stato ?? 'Da Svolgere';
                String? tappaIdSel = edit?.tappaId;
                DateTime dataOra = edit?.dataOra ?? DateTime.now();

                final tappeViaggio = provider.getTappeByViaggio(widget.viaggioId);

                showDialog(
                        context: context,
                        builder: (ctx) {
                                return StatefulBuilder(builder: (context, setDialogState) {
                                        return AlertDialog(
                                                title: Text(edit == null ? 'Nuova Attività' : 'Modifica Attività'),
                                                content: SingleChildScrollView(
                                                        child: Form(
                                                                key: formKey,
                                                                child: Column(
                                                                        children: [
                                                                                TextFormField(
                                                                                        controller: titCtrl,
                                                                                        decoration: const InputDecoration(labelText: 'Titolo'),
                                                                                        validator: (v) => v!.isEmpty ? 'Inserisci titolo' : null,
                                                                                ),
                                                                                TextFormField(
                                                                                        controller: descCtrl,
                                                                                        decoration: const InputDecoration(labelText: 'Descrizione'),
                                                                                ),
                                                                                TextFormField(
                                                                                        controller: luogoCtrl,
                                                                                        decoration: const InputDecoration(labelText: 'Luogo'),
                                                                                ),
                                                                                TextFormField(
                                                                                        controller: costoCtrl,
                                                                                        keyboardType: TextInputType.number,
                                                                                        decoration: const InputDecoration(labelText: 'Costo Stimato (€)'),
                                                                                ),
                                                                                TextFormField(
                                                                                        controller: noteCtrl,
                                                                                        decoration: const InputDecoration(labelText: 'Note'),
                                                                                ),
                                                                                DropdownButtonFormField<String>(
                                                                                        isExpanded: true,
                                                                                        initialValue: catSel,
                                                                                        decoration: const InputDecoration(labelText: 'Categoria'),
                                                                                        items: <String>['Visita', 'Escursione', 'Pasto', 'Spostamento', 'Evento', 'Altro']
                                                                                                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                                                                                .toList(),
                                                                                        onChanged: (v) => catSel = v!,
                                                                                ),
                                                                                DropdownButtonFormField<String>(
                                                                                        isExpanded: true,
                                                                                        initialValue: statoSel,
                                                                                        decoration: const InputDecoration(labelText: 'Stato Operativo'),
                                                                                        items: <String>['Da Svolgere', 'Completato', 'Annullato']
                                                                                                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                                                                                .toList(),
                                                                                        onChanged: (v) => statoSel = v!,
                                                                                ),
                                                                                DropdownButtonFormField<String?>(
                                                                                        isExpanded: true,
                                                                                        initialValue: tappaIdSel,
                                                                                        decoration: const InputDecoration(labelText: 'Collega a Tappa'),
                                                                                        items: [
                                                                                                const DropdownMenuItem<String?>(value: null, child: Text('Nessuna tappa')),
                                                                                                ...tappeViaggio.map((t) => DropdownMenuItem<String?>(
                                                                                                        value: t.id,
                                                                                                        child: Text('Tappa ${t.ordine}: ${t.titolo}'),
                                                                                                ))
                                                                                        ],
                                                                                        onChanged: (v) => tappaIdSel = v,
                                                                                ),
                                                                                const SizedBox(height: 12),
                                                                                Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                                Expanded(child: const Text('Data/Ora:')),
                                                                                                Expanded(
                                                                                                        child: TextButton(
                                                                                                                onPressed: () async {
                                                                                                                        final d = await showDatePicker(
                                                                                                                                context: context,
                                                                                                                                initialDate: dataOra,
                                                                                                                                firstDate: DateTime(2020),
                                                                                                                                lastDate: DateTime(2040),
                                                                                                                        );
                                                                                                                        if (d != null) {
                                                                                                                                final t = await showTimePicker(
                                                                                                                                        context: context,
                                                                                                                                        initialTime: TimeOfDay.fromDateTime(dataOra),
                                                                                                                                );
                                                                                                                                if (t != null) {
                                                                                                                                        setDialogState(() {
                                                                                                                                                dataOra = DateTime(d.year, d.month, d.day, t.hour, t.minute);
                                                                                                                                        });
                                                                                                                                }
                                                                                                                        }
                                                                                                                },
                                                                                                                child: Text("${dataOra.day}/${dataOra.month} alle ${dataOra.hour}:${dataOra.minute.toString().padLeft(2, '0')}"),
                                                                                                        )
                                                                                                )
                                                                                        ],
                                                                                )
                                                                        ],
                                                                ),
                                                        ),
                                                ),
                                                actions: [
                                                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annulla')),
                                                        ElevatedButton(
                                                                onPressed: () {
                                                                        if (formKey.currentState!.validate()) {
                                                                                final a = Attivita(
                                                                                        id: edit?.id ?? 'a_${DateTime.now().millisecondsSinceEpoch}',
                                                                                        viaggioId: widget.viaggioId,
                                                                                        tappaId: tappaIdSel,
                                                                                        titolo: titCtrl.text,
                                                                                        descrizione: descCtrl.text,
                                                                                        dataOra: dataOra,
                                                                                        luogo: luogoCtrl.text,
                                                                                        categoria: catSel,
                                                                                        costoPrevisto: double.tryParse(costoCtrl.text) ?? 0.0,
                                                                                        stato: statoSel,
                                                                                        note: noteCtrl.text,
                                                                                );
                                                                                if (edit == null) {
                                                                                        provider.addAttivita(a);
                                                                                } else {
                                                                                        provider.updateAttivita(a);
                                                                                }
                                                                                Navigator.pop(ctx);
                                                                        }
                                                                },
                                                                child: const Text('Salva'),
                                                        )
                                                ],
                                        );
                                });
                        },
                );
        }
}

class _ChecklistTab extends StatelessWidget {
        final String viaggioId;
        const _ChecklistTab({required this.viaggioId});

        @override
        Widget build(BuildContext context) {
                final provider = Provider.of<TravelProvider>(context);
                final checklist = provider.getChecklistByViaggio(viaggioId);

                return Scaffold(
                        body: Column(
                                children: [
                                        Container(
                                                padding: const EdgeInsets.all(10),
                                                color: Colors.amber.shade50,
                                                child: Row(
                                                        children: [
                                                                const Expanded(
                                                                        child: Text('Genera lista in base alla meta', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                                                ),
                                                                ElevatedButton(
                                                                        onPressed: () => _mostraDialogPackingListGeneratore(context, provider),
                                                                        child: const Text('Genera'),
                                                                )
                                                        ],
                                                ),
                                        ),
                                        Expanded(
                                                child: checklist.isEmpty
                                                        ? const Center(child: Text('Nessun elemento. Generane uno in valigia!'))
                                                        : ListView.builder(
                                                                itemCount: checklist.length,
                                                                itemBuilder: (context, idx) {
                                                                        final item = checklist[idx];
                                                                        return ListTile(
                                                                                leading: Checkbox(
                                                                                        value: item.completato,
                                                                                        onChanged: (_) => provider.toggleChecklistItem(item.id),
                                                                                ),
                                                                                title: Text(item.titolo, style: TextStyle(decoration: item.completato ? TextDecoration.lineThrough : null)),
                                                                                subtitle: Text(item.categoria),
                                                                                trailing: IconButton(
                                                                                        icon: const Icon(Icons.delete, color: Colors.red),
                                                                                        onPressed: () => provider.deleteChecklistItem(item.id),
                                                                                ),
                                                                        );
                                                                },
                                                        ),
                                        )
                                ],
                        ),
                        floatingActionButton: FloatingActionButton.small(
                                onPressed: () => _mostraDialogAggiungiElemento(context, provider),
                                child: const Icon(Icons.add),
                        ),
                );
        }

        void _mostraDialogPackingListGeneratore(BuildContext context, TravelProvider provider) {
                String catSel = 'Mare';
                showDialog(
                        context: context,
                        builder: (ctx) {
                                return AlertDialog(
                                        title: const Text('Seleziona Stile di Viaggio'),
                                        content: DropdownButtonFormField<String>(
                                                isExpanded: true,
                                                initialValue: catSel,
                                                items: <String>['Mare', 'Montagna', 'Città', 'Lavoro']
                                                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                                        .toList(),
                                                onChanged: (v) => catSel = v!,
                                        ),
                                        actions: [
                                                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annulla')),
                                                ElevatedButton(
                                                        onPressed: () {
                                                                provider.generaPackingListAutomatica(viaggioId, catSel);
                                                                Navigator.pop(ctx);
                                                        },
                                                        child: const Text('Crea Lista'),
                                                )
                                        ],
                                );
                        },
                );
        }

        void _mostraDialogAggiungiElemento(BuildContext context, TravelProvider provider) {
                final formKey = GlobalKey<FormState>();
                final titCtrl = TextEditingController();
                String catSel = 'Valigia';

                showDialog(
                        context: context,
                        builder: (ctx) {
                                return AlertDialog(
                                        title: const Text('Nuovo Elemento'),
                                        content: Form(
                                                key: formKey,
                                                child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                                TextFormField(
                                                                        controller: titCtrl,
                                                                        decoration: const InputDecoration(labelText: 'Cosa portare/fare'),
                                                                        validator: (v) => v!.isEmpty ? 'Specificare campo' : null,
                                                                ),
                                                                DropdownButtonFormField<String>(
                                                                        isExpanded: true,
                                                                        initialValue: catSel,
                                                                        items: <String>['Valigia', 'Documenti', 'Prima di partire', 'Altro']
                                                                                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                                                                .toList(),
                                                                        onChanged: (v) => catSel = v!,
                                                                )
                                                        ],
                                                ),
                                        ),
                                        actions: [
                                                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annulla')),
                                                ElevatedButton(
                                                        onPressed: () {
                                                                if (formKey.currentState!.validate()) {
                                                                        final item = ChecklistItem(
                                                                                id: 'c_${DateTime.now().millisecondsSinceEpoch}',
                                                                                viaggioId: viaggioId,
                                                                                titolo: titCtrl.text,
                                                                                completato: false,
                                                                                categoria: catSel,
                                                                        );
                                                                        provider.addChecklistItem(item);
                                                                        Navigator.pop(ctx);
                                                                }
                                                        },
                                                        child: const Text('Inserisci'),
                                                )
                                        ],
                                );
                        },
                );
        }
}

class _SpeseTab extends StatefulWidget {
        final String viaggioId;
        const _SpeseTab({required this.viaggioId});

        @override
        State<_SpeseTab> createState() => _SpeseTabState();
}

class _SpeseTabState extends State<_SpeseTab> {
        String _filtroTipo = 'Tutte'; // 'Tutte', 'Prevista', 'Effettiva'

        @override
        Widget build(BuildContext context) {
                final provider = Provider.of<TravelProvider>(context);
                final viaggio = provider.viaggi.firstWhere((v) => v.id == widget.viaggioId);
                final spese = provider.getSpeseByViaggio(widget.viaggioId).where((s) {
                        return _filtroTipo == 'Tutte' || s.tipo == _filtroTipo;
                }).toList();

                final stat = provider.calcolaStatisticheViaggio(widget.viaggioId);

                return Scaffold(
                        body: Column(
                                children: [
                                        _buildRiepilogoFinanziario(viaggio.budget, stat['previstaTot'], stat['effettivaTot']),
                                        _buildBarraFiltroSpese(),
                                        Expanded(
                                                child: spese.isEmpty
                                                        ? const Center(child: Text('Nessuna spesa inserita.'))
                                                        : ListView.builder(
                                                                itemCount: spese.length,
                                                                itemBuilder: (context, idx) {
                                                                        final s = spese[idx];
                                                                        final dStr = "${s.data.day}/${s.data.month}";
                                                                        return ListTile(
                                                                                leading: CircleAvatar(child: Text(s.tipo[0])),
                                                                                title: Text(s.titolo),
                                                                                subtitle: Text('$dStr • Cat: ${s.categoria} (${s.metodoPagamento})'),
                                                                                trailing: Row(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: [
                                                                                                Text('€${s.importo}', style: TextStyle(fontWeight: FontWeight.bold, color: s.tipo == 'Effettiva' ? Colors.red : Colors.orange)),
                                                                                                IconButton(
                                                                                                        icon: const Icon(Icons.delete, color: Colors.grey, size: 20),
                                                                                                        onPressed: () => provider.deleteSpesa(s.id),
                                                                                                )
                                                                                        ],
                                                                                ),
                                                                        );
                                                                },
                                                        ),
                                        )
                                ],
                        ),
                        floatingActionButton: FloatingActionButton.small(
                                onPressed: () => _mostraDialogSpesa(context, provider),
                                child: const Icon(Icons.add),
                        ),
                );
        }

        Widget _buildBarraFiltroSpese() {
                return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Row(
                                children: [
                                        const Text('Filtra Tipologia: '),
                                        const SizedBox(width: 8),
                                        DropdownButton<String>(
                                                value: _filtroTipo,
                                                items: <String>['Tutte', 'Prevista', 'Effettiva']
                                                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                                        .toList(),
                                                onChanged: (v) => setState(() => _filtroTipo = v ?? 'Tutte'),
                                        )
                                ],
                        ),
                );
        }

        Widget _buildRiepilogoFinanziario(double budget, double previstTot, double effettivTot) {
                final diff = budget - effettivTot;
                return Card(
                        margin: const EdgeInsets.all(10),
                        color: Colors.teal.shade50,
                        child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                                _buildInfoCol('Budget Max', '€${budget.toStringAsFixed(1)}', Colors.black),
                                                _buildInfoCol('Spese Previste', '€${previstTot.toStringAsFixed(1)}', Colors.orange),
                                                _buildInfoCol('Spese Effettive', '€${effettivTot.toStringAsFixed(1)}', Colors.red),
                                                _buildInfoCol('Rimanente', '€${diff.toStringAsFixed(1)}', diff >= 0 ? Colors.green : Colors.red),
                                        ],
                                ),
                        ),
                );
        }

        Widget _buildInfoCol(String lbl, String value, Color col) {
                return Column(
                        children: [
                                Text(lbl, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                const SizedBox(height: 4),
                                Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: col)),
                        ],
                );
        }

        void _mostraDialogSpesa(BuildContext context, TravelProvider provider) {
                final formKey = GlobalKey<FormState>();
                final titCtrl = TextEditingController();
                final impCtrl = TextEditingController();
                final noteCtrl = TextEditingController();
                String catSel = 'Cibo';
                String pagSel = 'Contanti';
                String tipoSel = 'Effettiva';
                DateTime data = DateTime.now();

                showDialog(
                        context: context,
                        builder: (ctx) {
                                return StatefulBuilder(builder: (context, setDialogState) {
                                        return AlertDialog(
                                                title: const Text('Aggiungi Spesa'),
                                                content: SingleChildScrollView(
                                                        child: Form(
                                                                key: formKey,
                                                                child: Column(
                                                                        children: [
                                                                                TextFormField(
                                                                                        controller: titCtrl,
                                                                                        decoration: const InputDecoration(labelText: 'Nome Spesa'),
                                                                                        validator: (v) => v!.isEmpty ? 'Inserire titolo' : null,
                                                                                ),
                                                                                TextFormField(
                                                                                        controller: impCtrl,
                                                                                        keyboardType: TextInputType.number,
                                                                                        decoration: const InputDecoration(labelText: 'Importo (€)'),
                                                                                        validator: (v) => v!.isEmpty ? 'Inserire importo' : null,
                                                                                ),
                                                                                DropdownButtonFormField<String>(
                                                                                        isExpanded: true,
                                                                                        initialValue: tipoSel,
                                                                                        decoration: const InputDecoration(labelText: 'Tipo Spesa'),
                                                                                        items: <String>['Prevista', 'Effettiva']
                                                                                                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                                                                                .toList(),
                                                                                        onChanged: (v) => tipoSel = v!,
                                                                                ),
                                                                                DropdownButtonFormField<String>(
                                                                                        isExpanded: true,
                                                                                        initialValue: catSel,
                                                                                        decoration: const InputDecoration(labelText: 'Categoria spesa'),
                                                                                        items: <String>['Cibo', 'Trasporti', 'Alloggio', 'Attività', 'Altro']
                                                                                                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                                                                                .toList(),
                                                                                        onChanged: (v) => catSel = v!,
                                                                                ),
                                                                                DropdownButtonFormField<String>(
                                                                                        isExpanded: true,
                                                                                        initialValue: pagSel,
                                                                                        decoration: const InputDecoration(labelText: 'Metodo di Pagamento'),
                                                                                        items: <String>['Carta', 'Contanti']
                                                                                                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                                                                                .toList(),
                                                                                        onChanged: (v) => pagSel = v!,
                                                                                ),
                                                                                TextFormField(
                                                                                        controller: noteCtrl,
                                                                                        decoration: const InputDecoration(labelText: 'Note'),
                                                                                ),
                                                                        ],
                                                                ),
                                                        ),
                                                ),
                                                actions: [
                                                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annulla')),
                                                        ElevatedButton(
                                                                onPressed: () {
                                                                        if (formKey.currentState!.validate()) {
                                                                                final s = Spesa(
                                                                                        id: 's_${DateTime.now().millisecondsSinceEpoch}',
                                                                                        viaggioId: widget.viaggioId,
                                                                                        titolo: titCtrl.text,
                                                                                        importo: double.tryParse(impCtrl.text) ?? 0.0,
                                                                                        categoria: catSel,
                                                                                        data: data,
                                                                                        metodoPagamento: pagSel,
                                                                                        tipo: tipoSel,
                                                                                        note: noteCtrl.text,
                                                                                );
                                                                                provider.addSpesa(s);
                                                                                Navigator.pop(ctx);
                                                                        }
                                                                },
                                                                child: const Text('Registra'),
                                                        )
                                                ],
                                        );
                                });
                        },
                );
        }
}

class _InfoStatTab extends StatelessWidget {
        final String viaggioId;
        const _InfoStatTab({required this.viaggioId});

        @override
        Widget build(BuildContext context) {
                final provider = Provider.of<TravelProvider>(context);
                final viaggio = provider.viaggi.firstWhere((v) => v.id == viaggioId);
                final stat = provider.calcolaStatisticheViaggio(viaggioId);

                return SingleChildScrollView(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                        _buildCardDettaglioGenerale(context, viaggio),
                                        const SizedBox(height: 10),
                                        _buildCardAnalisiViaggio(stat),
                                ],
                        ),
                );
        }

        Widget _buildCardDettaglioGenerale(BuildContext context, Viaggio viaggio) {
                return Card(
                        elevation: 3,
                        child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                                Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                                const Text('Dettagli Generali', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
                                                                const Icon(Icons.info_outline, color: Colors.teal)
                                                        ],
                                                ),
                                                const Divider(),
                                                Text('📍 Destinazione Principale: ${viaggio.destinazione}', style: const TextStyle(fontSize: 14)),
                                                const SizedBox(height: 6),
                                                Text('📝 Descrizione: ${viaggio.descrizione}'),
                                                const SizedBox(height: 6),
                                                Text('👥 Partecipanti: ${viaggio.partecipanti.isEmpty ? 'Nessun altro' : viaggio.partecipanti.join(', ')}'),
                                                const SizedBox(height: 12),
                                                const Text('📞 Informazioni Utili Generali / Numeri d\'emergenza:', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Text(viaggio.infoGenerali.isEmpty ? 'Nessuna nota di emergenza inserita.' : viaggio.infoGenerali),
                                        ],
                                ),
                        ),
                );
        }

        Widget _buildCardAnalisiViaggio(Map<String, dynamic> stat) {
                final attFatte = stat['attFatte'] ?? 0;
                final attTot = stat['attTot'] ?? 0;
                final checkFatte = stat['checkFatte'] ?? 0;
                final checkTot = stat['checkTot'] ?? 0;

                return Card(
                        elevation: 3,
                        child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                                const Text('Analisi Avanzamento Viaggio', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
                                                const Divider(),
                                                _buildAvanzamentoWidget('Attività Completate', attFatte, attTot, Colors.teal),
                                                const SizedBox(height: 14),
                                                _buildAvanzamentoWidget('Elementi in Valigia', checkFatte, checkTot, Colors.blue),
                                        ],
                                ),
                        ),
                );
        }

        Widget _buildAvanzamentoWidget(String title, int fatte, int tot, Color col) {
                final double perc = tot > 0 ? (fatte / tot) : 0.0;
                return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                                Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                                Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
                                                Text('$fatte su $tot (${(perc * 100).toStringAsFixed(0)}%)'),
                                        ],
                                ),
                                const SizedBox(height: 6),
                                LinearProgressIndicator(
                                        value: perc,
                                        color: col,
                                        backgroundColor: Colors.grey.shade200,
                                        minHeight: 8,
                                )
                        ],
                );
        }
}
