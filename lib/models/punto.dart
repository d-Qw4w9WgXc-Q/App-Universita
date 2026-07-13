class Punto{
        int? id;
        int viaggioId;
        String descrizione;
        bool stato;

        Punto({
                this.id,
                required this.viaggio_id,
                required this.descrizione,
                this.stato = false
        });

        Map<String, dynamic> toMap(){
                return {
                        'id': id,
                        'viaggio_id': viaggioId,
                        'descrizione': descrizione,
                        'stato': stato ? 1 : 0
                };
        }

        factory Punto.fromMap(Map<String, dynamic> map) {
                return Punto(
                        id: map['id'],
                        viaggioId: map['viaggio_id'],
                        descrizione: map['descrizione'],
                        stato: map['stato'] == 1
                );
        }
}