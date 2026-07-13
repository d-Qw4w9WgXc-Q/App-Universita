import 'package:flutter/material.dart';
import 'package:viaggiare/models/viaggio.dart';
import 'package:viaggiare/widgets/campo_testo.dart';

class ViaggioPage extends StatefulWidget {
        const ViaggioPage({super.key});

        @override
        State<StatefulWidget> createState() => ViaggioPageState();
}

class ViaggioPageState extends State<ViaggioPage> with AutomaticKeepAliveClientMixin {
        late final TextEditingController _titoloController;
        late final TextEditingController _descrizioneController;

        Viaggio get viaggio => Viaggio(titolo: _titoloController.text, descrizione: _descrizioneController.text);

        @override
        void initState() {
                _titoloController = TextEditingController();
                _descrizioneController = TextEditingController();
                super.initState();
        }

        @override
        void dispose() {
                _titoloController.dispose();
                _descrizioneController.dispose();
                super.dispose();
        }

        @override
        Widget build(BuildContext context) {
                super.build(context);
                return Scaffold(
                        appBar: AppBar(
                                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                                title: Text('Viaggio'),
                        ),
                        body: Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                        children: [
                                                CampoTesto(hintText: 'Titolo', controller: _titoloController),
                                                SizedBox(height: 8),
                                                CampoTesto(hintText: 'Descrizione', maxLines: null, controller: _descrizioneController)
                                        ]
                                )
                        ),
                );
        }

        @override
        bool get wantKeepAlive => true;
}
