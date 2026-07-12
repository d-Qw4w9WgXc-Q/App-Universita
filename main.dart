import 'package:flutter/material.dart';
import 'edit_page.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
        const App({super.key});
        
        // This widget is the root of your application.
        @override
        Widget build(BuildContext context) {
                return MaterialApp(
                        title: 'Flutter Demo',
                        theme: ThemeData(
                                colorScheme: .fromSeed(seedColor: Colors.orangeAccent),
                        ),
                        home: const HomePage(title: 'I tuoi viaggi'),
                );
        }
}

class HomePage extends StatefulWidget {
        const HomePage({super.key, required this.title});

        final String title;

        @override
        State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
        final List<Text> _viaggi = [];

        void _addViaggio() {
                setState(() {
                        
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
                                onPressed: () {
                                        Navigator.push(
                                                context,
                                                MaterialPageRoute<void>(
                                                        builder: (constext) => const EditPage()
                                                )
                                        );
                                },
                                tooltip: 'Aggiungi Viaggio',
                                child: const Icon(Icons.add),
                        ),
                );
        }
}
