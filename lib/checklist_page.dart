import 'package:flutter/material.dart';
import 'checklist_punto.dart';

class ChecklistPage extends StatefulWidget {
        const ChecklistPage({super.key});

        @override
        State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> with AutomaticKeepAliveClientMixin {
        List<ChecklistPunto> _punti = [];

        @override
        Widget build(BuildContext context) {
                super.build(context);
                return Scaffold(
                        appBar: AppBar(
                                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                                title: Text('Checklist'),
                        ),
                        body: ReorderableListView.builder(
                                buildDefaultDragHandles: false,
                                itemCount: _punti.length,
                                itemBuilder: (context, index) => ListTile(
                                        title: _punti[index],
                                        key: ObjectKey(_punti[index].id),

                                        trailing: ReorderableDragStartListener(
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

                                                final item = _punti.removeAt(oldIndex);
                                                _punti.insert(newIndex, item);
                                        });
                                }
                        ),
                        floatingActionButton: FloatingActionButton(
                                onPressed: () {
                                        setState(() {
                                                _punti.add(ChecklistPunto());
                                        });
                                },
                                child: Icon(Icons.add)
                        ),
                );
        }

        @override
        bool get wantKeepAlive => true;
}
