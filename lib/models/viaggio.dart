class Viaggio {
        String id;
        String titolo;
        String destinazione;
        DateTime dataInizio;
        DateTime dataFine;
        String descrizione;
        String stato; // 'Futuro', 'In Corso', 'Completato', 'Archiviato'
        double budget;
        List<String> partecipanti;
        String infoGenerali;

        Viaggio({
                required this.id,
                required this.titolo,
                required this.destinazione,
                required this.dataInizio,
                required this.dataFine,
                required this.descrizione,
                required this.stato,
                required this.budget,
                required this.partecipanti,
                required this.infoGenerali,
        });

        Map<String, dynamic> toJson() {
                return {
                        'id': id,
                        'titolo': titolo,
                        'destinazione': destinazione,
                        'dataInizio': dataInizio.toIso8601String(),
                        'dataFine': dataFine.toIso8601String(),
                        'descrizione': descrizione,
                        'stato': stato,
                        'budget': budget,
                        'partecipanti': partecipanti,
                        'infoGenerali': infoGenerali,
                };
        }

        factory Viaggio.fromJson(Map<String, dynamic> json) {
                return Viaggio(
                        id: json['id'] ?? '',
                        titolo: json['titolo'] ?? '',
                        destinazione: json['destinazione'] ?? '',
                        dataInizio: DateTime.parse(json['dataInizio']),
                        dataFine: DateTime.parse(json['dataFine']),
                        descrizione: json['descrizione'] ?? '',
                        stato: json['stato'] ?? 'Futuro',
                        budget: (json['budget'] ?? 0.0).toDouble(),
                        partecipanti: List<String>.from(json['partecipanti'] ?? []),
                        infoGenerali: json['infoGenerali'] ?? '',
                );
        }

        Viaggio copyWith({
                String? id,
                String? titolo,
                String? destinazione,
                DateTime? dataInizio,
                DateTime? dataFine,
                String? descrizione,
                String? stato,
                double? budget,
                List<String>? partecipanti,
                String? infoGenerali,
        }) {
                return Viaggio(
                        id: id ?? this.id,
                        titolo: titolo ?? this.titolo,
                        destinazione: destinazione ?? this.destinazione,
                        dataInizio: dataInizio ?? this.dataInizio,
                        dataFine: dataFine ?? this.dataFine,
                        descrizione: descrizione ?? this.descrizione,
                        stato: stato ?? this.stato,
                        budget: budget ?? this.budget,
                        partecipanti: partecipanti ?? this.partecipanti,
                        infoGenerali: infoGenerali ?? this.infoGenerali,
                );
        }
}
