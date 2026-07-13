class Attivita {
        int? id;
        int viaggioId;
        String titolo;
        String? descrizione;
        DateTime? inizio;
        DateTime? fine;
        String? luogo;
        String? categoria;
        int? costo;
        bool stato;

        Attivita({
                this.id,
                required this.viaggioId,
                required this.titolo,
                this.descrizione,
                this.inizio,
                this.fine,
                this.luogo,
                this.categoria,
                this.costo,
                this.stato = false
        });

        Map<String, dynamic> toMap(){
                return {
                        'id': id,
                        'viaggio_id': viaggioId,
                        'titolo': titolo,
                        'descrizione': descrizione,
                        'inizio': inizio?.toIso8601String(),
                        'fine': fine?.toIso8601String(),
                        'luogo': luogo,
                        'categoria': categoria,
                        'costo': costo,
                        'stato': stato ? 1 : 0
                };
        }

        factory Attivita.fromMap(Map<String, dynamic> map) {
                return Attivita(
                        id: map['id'],
                        viaggioId: map['viaggio_id'],
                        titolo: map['titolo'],
                        descrizione: map['descrizione'],
                        inizio: map['inizio'] != null ? DateTime.parse(map['inizio']) : null,
                        fine: map['fine'] != null ? DateTime.parse(map['fine']) : null,
                        luogo: map['luogo'],
                        categoria: map['categoria'],
                        costo: map['costo'],
                        stato: map['stato'] == 1
                );
        }
}