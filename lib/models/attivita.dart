class Attivita {
        String id;
        String viaggioId;
        String? tappaId; // Opzionale
        String titolo;
        String descrizione;
        DateTime dataOra;
        String luogo;
        String categoria; // 'Visita', 'Escursione', 'Pasto', 'Spostamento', 'Evento', 'Altro'
        double costoPrevisto;
        String stato; // 'Da Svolgere', 'Completato', 'Annullato'
        String note;

        Attivita({
                required this.id,
                required this.viaggioId,
                this.tappaId,
                required this.titolo,
                required this.descrizione,
                required this.dataOra,
                required this.luogo,
                required this.categoria,
                required this.costoPrevisto,
                required this.stato,
                required this.note,
        });

        Map<String, dynamic> toJson() {
                return {
                        'id': id,
                        'viaggioId': viaggioId,
                        'tappaId': tappaId,
                        'titolo': titolo,
                        'descrizione': descrizione,
                        'dataOra': dataOra.toIso8601String(),
                        'luogo': luogo,
                        'categoria': categoria,
                        'costoPrevisto': costoPrevisto,
                        'stato': stato,
                        'note': note,
                };
        }

        factory Attivita.fromJson(Map<String, dynamic> json) {
                return Attivita(
                        id: json['id'] ?? '',
                        viaggioId: json['viaggioId'] ?? '',
                        tappaId: json['tappaId'],
                        titolo: json['titolo'] ?? '',
                        descrizione: json['descrizione'] ?? '',
                        dataOra: DateTime.parse(json['dataOra']),
                        luogo: json['luogo'] ?? '',
                        categoria: json['categoria'] ?? 'Altro',
                        costoPrevisto: (json['costoPrevisto'] ?? 0.0).toDouble(),
                        stato: json['stato'] ?? 'Da Svolgere',
                        note: json['note'] ?? '',
                );
        }

        Attivita copyWith({
                String? id,
                String? viaggioId,
                String? tappaId,
                String? titolo,
                String? descrizione,
                DateTime? dataOra,
                String? luogo,
                String? categoria,
                double? costoPrevisto,
                String? stato,
                String? note,
        }) {
                return Attivita(
                        id: id ?? this.id,
                        viaggioId: viaggioId ?? this.viaggioId,
                        tappaId: tappaId ?? this.tappaId,
                        titolo: titolo ?? this.titolo,
                        descrizione: descrizione ?? this.descrizione,
                        dataOra: dataOra ?? this.dataOra,
                        luogo: luogo ?? this.luogo,
                        categoria: categoria ?? this.categoria,
                        costoPrevisto: costoPrevisto ?? this.costoPrevisto,
                        stato: stato ?? this.stato,
                        note: note ?? this.note,
                );
        }
}
