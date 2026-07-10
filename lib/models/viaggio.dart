class Viaggio {
        int? id;
        String titolo;
        String? destinazione;
        DateTime? inizio;
        DateTime? fine;
        String? descrizione;
        bool stato;
        double? budget;

        Viaggio({
                this.id,
                required this.titolo,
                this.destinazione,
                this.inizio,
                this.fine,
                this.descrizione,
                this.stato = false,
                this.budget
        });

        Map<String, dynamic> toMap(){
                return {
                        'id': id,
                        'titolo': titolo,
                        'destinazione': destinazione,
                        'inizio': inizio?.toIso8601String(),
                        'fine': fine?.toIso8601String(),
                        'descrizione': descrizione,
                        'stato': stato ? 1 : 0,
                        'budget': budget
                };
        }

        factory Viaggio.fromMap(Map<String, dynamic> map) {
                return Viaggio(
                        id: map['id'],
                        titolo: map['titolo'],
                        destinazione: map['destinazione'],
                        inizio: map['inizio'] != null ? DateTime.parse(map['inizio']) : null,
                        fine: map['fine'] != null ? DateTime.parse(map['fine']) : null,
                        descrizione: map['descrizione'],
                        stato: map['stato'] == 1,
                        budget: map['budget']?.toDouble()
                );
        }
}