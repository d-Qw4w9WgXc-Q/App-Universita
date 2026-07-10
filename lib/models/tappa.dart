class Tappa {
        int? id;
        int viaggioId;
        String titolo;
        DateTime? data;
        String? luogo;
        String? descrizione;

        Tappa({
                this.id,
                required this.viaggioId,
                required this.titolo,
                this.data,
                this.luogo,
                this.descrizione
        });

        Map<String, dynamic> toMap(){
                return {
                        'id': id,
                        'viaggio_id': viaggioId,
                        'titolo': titolo,
                        'data': data?.toIso8601String(),
                        'luogo': luogo,
                        'descrizione': descrizione
                };
        }

        factory Tappa.fromMap(Map<String, dynamic> map) {
                return Tappa(
                        id: map['id'],
                        viaggioId: map['viaggio_id'],
                        titolo: map['titolo'],
                        data: map['data'] != null ? DateTime.parse(map['data']) : null,
                        luogo: map['luogo'],
                        descrizione: map['descrizione']
                );
        }
}