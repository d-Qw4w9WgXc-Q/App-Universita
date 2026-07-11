class Spesa {
        int? id;
        String titolo;
        double? importo;
        String? categoria;
        DateTime? data;
        int viaggioId;
        int tappaId;
        int attivitaId;
        String? metodoPagamento;
        bool stato;

        Spesa({
                this.id,
                required this.titolo,
                this.importo,
                this.categoria,
                this.data,
                required this.viaggioId,
                required this.tappaId,
                required this.attivitaId,
                this.metodoPagamento,
                this.stato = false
        });

        Map<String, dynamic> toMap(){
                return {
                        'id': id,
                        'titolo': titolo,
                        'importo': importo,
                        'categoria': categoria,
                        'data': data?.toIso8601String(),
                        'viaggio_id': viaggioId,
                        'tappa_id': tappaId,
                        'attivita_id': attivitaId,
                        'metodo_pagamento': metodoPagamento,
                        'stato': stato ? 1 : 0
                };
        }

        factory Spesa.fromMap(Map<String, dynamic> map) {
                return Spesa(
                        id: map['id'],
                        titolo: map['titolo'],
                        importo: map['importo'],
                        categoria: map['categoria'],
                        data: map['data'] != null ? DateTime.parse(map['data']) : null,
                        viaggioId: map['viaggio_id'],
                        tappaId: map['tappa_id'],
                        attivitaId: map['attivita_id'],
                        metodoPagamento: map['metodo_pagamento'],
                        stato: map['stato'] == 1
                );
        }
}