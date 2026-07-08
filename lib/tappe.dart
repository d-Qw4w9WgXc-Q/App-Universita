import 'package:flutter/material.dart';

class Tappe extends StatefulWidget {
        const Tappe({super.key});

        @override
        State<Tappe> createState() => _TappeState();
}

class _TappeState extends State<Tappe> {
        @override
        Widget build(BuildContext context) {
                return Scaffold(
                        appBar: AppBar(
                                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                                title: Text('Tappe'),
                        ),
                );
        }
}
