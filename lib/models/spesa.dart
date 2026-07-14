class Spesa {
        String id;
        String viaggioId;
        String? attivitaId; // Collegamento facoltativo
        String titolo;
        double importo;
        String categoria; // 'Cibo', 'Trasporti', 'Alloggio', 'Attività', 'Altro'
        DateTime data;
        String metodoPagamento; // 'Carta', 'Contanti'
        String tipo; // 'Prevista', 'Effettiva'
        String note;

        Spesa({
                required this.id,
                required this.viaggioId,
                this.attivitaId,
                required this.titolo,
                required this.importo,
                required this.categoria,
                required this.data,
                required this.metodoPagamento,
                required this.tipo,
                required this.note,
        });

        Map<String, dynamic> toJson() {
                return {
                        'id': id,
                        'viaggioId': viaggioId,
                        'attivitaId': attivitaId,
                        'titolo': titolo,
                        'importo': importo,
                        'categoria': categoria,
                        'data': data.toIso8601String(),
                        'metodoPagamento': metodoPagamento,
                        'tipo': tipo,
                        'note': note,
                };
        }

        factory Spesa.fromJson(Map<String, dynamic> json) {
                return Spesa(
                        id: json['id'] ?? '',
                        viaggioId: json['viaggioId'] ?? '',
                        attivitaId: json['attivitaId'],
                        titolo: json['titolo'] ?? '',
                        importo: (json['importo'] ?? 0.0).toDouble(),
                        categoria: json['categoria'] ?? 'Altro',
                        data: DateTime.parse(json['data']),
                        metodoPagamento: json['metodoPagamento'] ?? 'Contanti',
                        tipo: json['tipo'] ?? 'Effettiva',
                        note: json['note'] ?? '',
                );
        }

        Spesa copyWith({
                String? id,
                String? viaggioId,
                String? attivitaId,
                String? titolo,
                double? importo,
                String? categoria,
                DateTime? data,
                String? metodoPagamento,
                String? tipo,
                String? note,
        }) {
                return Spesa(
                        id: id ?? this.id,
                        viaggioId: viaggioId ?? this.viaggioId,
                        attivitaId: attivitaId ?? this.attivitaId,
                        titolo: titolo ?? this.titolo,
                        importo: importo ?? this.importo,
                        categoria: categoria ?? this.categoria,
                        data: data ?? this.data,
                        metodoPagamento: metodoPagamento ?? this.metodoPagamento,
                        tipo: tipo ?? this.tipo,
                        note: note ?? this.note,
                );
        }
}
