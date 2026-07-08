import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
        const MyApp({super.key});
        
        // This widget is the root of your application.
        @override
        Widget build(BuildContext context) {
                return MaterialApp(
                        title: 'Flutter Demo',
                        theme: ThemeData(
                                colorScheme: .fromSeed(seedColor: Colors.orangeAccent),
                        ),
                        home: const MyHomePage(title: 'I tuoi viaggi'),
                );
        }
}

class MyHomePage extends StatefulWidget {
        const MyHomePage({super.key, required this.title});

        final String title;

        @override
        State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
        final List<Text> _viaggi = [];

        void _addViaggio() {
                setState(() {
                        _viaggi.add(Text('culo'));
                });
        }
        
        @override
        Widget build(BuildContext context) {
                return Scaffold(
                        appBar: AppBar(
                                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                                title: Text(widget.title),
                        ),
                        body: ListView.builder(
                                itemCount: _viaggi.length,
                                itemBuilder: (context, index) => ListTile(title: _viaggi[index]),
                        ),
                        floatingActionButton: FloatingActionButton(
                                onPressed: _addViaggio,
                                tooltip: 'Aggiungi Viaggio',
                                child: const Icon(Icons.add),
                        ),
                );
        }
}
