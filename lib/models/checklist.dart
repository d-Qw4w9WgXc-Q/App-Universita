class ChecklistItem {
        String id;
        String viaggioId;
        String titolo;
        bool completato;
        String categoria; // 'Valigia', 'Documenti', 'Prima di partire', 'Altro'

        ChecklistItem({
                required this.id,
                required this.viaggioId,
                required this.titolo,
                required this.completato,
                required this.categoria,
        });

        Map<String, dynamic> toJson() {
                return {
                        'id': id,
                        'viaggioId': viaggioId,
                        'titolo': titolo,
                        'completato': completato,
                        'categoria': categoria,
                };
        }

        factory ChecklistItem.fromJson(Map<String, dynamic> json) {
                return ChecklistItem(
                        id: json['id'] ?? '',
                        viaggioId: json['viaggioId'] ?? '',
                        titolo: json['titolo'] ?? '',
                        completato: json['completato'] ?? false,
                        categoria: json['categoria'] ?? 'Altro',
                );
        }

        ChecklistItem copyWith({
                String? id,
                String? viaggioId,
                String? titolo,
                bool? completato,
                String? categoria,
        }) {
                return ChecklistItem(
                        id: id ?? this.id,
                        viaggioId: viaggioId ?? this.viaggioId,
                        titolo: titolo ?? this.titolo,
                        completato: completato ?? this.completato,
                        categoria: categoria ?? this.categoria,
                );
        }
}
