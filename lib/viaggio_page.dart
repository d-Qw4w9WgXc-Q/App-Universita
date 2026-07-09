import 'package:flutter/material.dart';
import 'campo_testo.dart';

class ViaggioPage extends StatefulWidget {
        const ViaggioPage({super.key});

        @override
        State<StatefulWidget> createState() => _ViaggioPageState();
}

class _ViaggioPageState extends State<ViaggioPage> with AutomaticKeepAliveClientMixin {
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
                                                CampoTesto(hintText: 'Titolo'),
                                                SizedBox(height: 8),
                                                CampoTesto(hintText: 'Descrizione', maxLines: null)
                                        ]
                                )
                        ),
                );
        }

        @override
        bool get wantKeepAlive => true;
}
