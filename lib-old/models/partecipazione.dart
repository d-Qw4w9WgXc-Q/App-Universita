class Partecipazione {
        int? id;
        int partecipanteId;
        int viaggioId;

        Partecipazione({
                this.id,
                required this.partecipanteId,
                required this.viaggioId
        });

        Map<String, dynamic> toMap(){
                return {
                        'id': id,
                        'partecipante_id': partecipanteId,
                        'viaggio_id': viaggioId
                };
        }

        factory Partecipazione.fromMap(Map<String, dynamic> map) {
                return Partecipazione(
                        id: map['id'],
                        partecipanteId: map['partecipante_id'],
                        viaggioId: map['viaggio_id']
                );
        }
}