class Tappa {
        String id;
        String viaggioId;
        String titolo;
        DateTime data;
        String localita;
        String descrizione;
        int ordine;
        String note;

        Tappa({
                required this.id,
                required this.viaggioId,
                required this.titolo,
                required this.data,
                required this.localita,
                required this.descrizione,
                required this.ordine,
                required this.note,
        });

        Map<String, dynamic> toJson() {
                return {
                        'id': id,
                        'viaggioId': viaggioId,
                        'titolo': titolo,
                        'data': data.toIso8601String(),
                        'localita': localita,
                        'descrizione': descrizione,
                        'ordine': ordine,
                        'note': note,
                };
        }

        factory Tappa.fromJson(Map<String, dynamic> json) {
                return Tappa(
                        id: json['id'] ?? '',
                        viaggioId: json['viaggioId'] ?? '',
                        titolo: json['titolo'] ?? '',
                        data: DateTime.parse(json['data']),
                        localita: json['localita'] ?? '',
                        descrizione: json['descrizione'] ?? '',
                        ordine: json['ordine'] ?? 0,
                        note: json['note'] ?? '',
                );
        }

        Tappa copyWith({
                String? id,
                String? viaggioId,
                String? titolo,
                DateTime? data,
                String? localita,
                String? descrizione,
                int? ordine,
                String? note,
        }) {
                return Tappa(
                        id: id ?? this.id,
                        viaggioId: viaggioId ?? this.viaggioId,
                        titolo: titolo ?? this.titolo,
                        data: data ?? this.data,
                        localita: localita ?? this.localita,
                        descrizione: descrizione ?? this.descrizione,
                        ordine: ordine ?? this.ordine,
                        note: note ?? this.note,
                );
        }
}
