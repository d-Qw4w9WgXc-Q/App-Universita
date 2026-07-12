class Partecipante {
        int? id;
        String? nome;
        String? cognome;

        Partecipante({this.id,
                required this.nome,
                required this.cognome
                });
        
        Map<String, dynamic> toMap(){
                return {'id': id,
                        'nome': nome,
                        'cognome': cognome
                };
        }

        factory Partecipante.fromMap(Map<String, dynamic> map) {
                return Partecipante(
                        id: map['id'],
                        nome: map['nome'],
                        cognome: map['cognome']
                        );
        }
}