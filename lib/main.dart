import 'package:flutter/material.dart';
import 'package:viaggiare/models/viaggio.dart';
import 'package:viaggiare/widgets/viaggio_preview.dart';
import 'pages/edit_page.dart';
import 'widgets/empty_page.dart';

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
        final List<ViaggioPreview> _viaggi = [];

        void _addViaggio({required Viaggio viaggio}) {
                setState(() {
                        _viaggi.add(
                                ViaggioPreview(
                                        key: UniqueKey(),
                                        viaggio: viaggio
                                )
                        );
                });
        }
        
        @override
        Widget build(BuildContext context) {
                return Scaffold(
                        appBar: AppBar(
                                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                                title: Text(widget.title),
                        ),
                        body: _viaggi.isEmpty ?
                        EmptyPage(
                                icon: Icons.flight_takeoff,
                                text: 'Non hai ancora nessun viaggio',
                        ) :
                        
                        ReorderableListView.builder(
                                padding: EdgeInsets.only(bottom: 200),
                                buildDefaultDragHandles: false,
                                itemCount: _viaggi.length,
                                itemBuilder: (context, index) => ListTile(
                                        title: _viaggi[index],
                                        key: _viaggi[index].key,

                                        leading: ReorderableDragStartListener(
                                                index: index,
                                                child: Listener(
                                                        onPointerDown: (_) {
                                                                FocusManager.instance.primaryFocus?.unfocus();
                                                        },
                                                        child:Icon(Icons.drag_handle)
                                                )
                                        ),
                                ),

                                onReorderItem: (int oldIndex, int newIndex) {
                                        setState(() {

                                                final item = _viaggi.removeAt(oldIndex);
                                                _viaggi.insert(newIndex, item);
                                        });
                                }
                        ),
                        floatingActionButton: FloatingActionButton(
                                heroTag: 'main_add',
                                onPressed: () {
                                        Navigator.push(
                                                context,
                                                MaterialPageRoute<void>(
                                                        builder: (constext) => EditPage(onSave: _addViaggio)
                                                )
                                        );
                                },
                                tooltip: 'Aggiungi Viaggio',
                                child: const Icon(Icons.add),
                        ),
                );
        }
}
