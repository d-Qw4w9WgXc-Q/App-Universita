import 'package:flutter/material.dart';
import 'campo_testo.dart';
import 'tappe.dart';

class Viaggio extends StatefulWidget {
        const Viaggio({super.key});

        @override
        State<StatefulWidget> createState() => _ViaggioState();
}

class _ViaggioState extends State<Viaggio> {
        @override
        Widget build(BuildContext context) {
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
                        floatingActionButton: FloatingActionButton(
                                onPressed: () {
                                        Navigator.push(context, 
                                                MaterialPageRoute<void>(
                                                        builder: (context) => Tappe()
                                                )
                                        );
                                },
                                tooltip: 'Continua',
                                child: Icon(Icons.keyboard_double_arrow_right)
                        )
                );
        }
}
