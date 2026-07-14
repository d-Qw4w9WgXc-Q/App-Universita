import 'package:flutter/material.dart';

class FullViaggioController extends ChangeNotifier {

        FullViaggioController({this.key, this._titolo, this._descrizione});

        final Key? key;

        String? _titolo;
        String? _descrizione;

        String? get titolo => _titolo;
        String? get descrizione => _descrizione;

        set titolo(String? titolo) {
                _titolo = titolo;
                notifyListeners();
        }

        set descrizione(String? descrizione) {
                _descrizione = descrizione;
                notifyListeners();
        }
}

