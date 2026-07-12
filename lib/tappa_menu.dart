import 'package:flutter/material.dart';

class TappaMenu extends StatefulWidget {
        const TappaMenu({super.key});

        @override
        State<TappaMenu> createState() => _TappaMenuState();
}

class _TappaMenuState extends State<TappaMenu> {
        @override
        Widget build(BuildContext context) {
                return Scaffold(
                        appBar: AppBar(
                                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                                title: Text('Tappa')
                        )
                );
        }
}
