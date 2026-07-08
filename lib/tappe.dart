import 'package:flutter/material.dart';
import 'tappa_preview.dart';

class Tappe extends StatefulWidget {
        const Tappe({super.key});

        @override
        State<Tappe> createState() => _TappeState();
}


class _TappeState extends State<Tappe> {
        final List<TappaPreview> _tappe = [];

        @override
        Widget build(BuildContext context) {
                return Scaffold(
                        appBar: AppBar(
                                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                                title: Text('Tappe'),
                        ),
                        body: ReorderableListView.builder(
                                buildDefaultDragHandles: false,
                                itemCount: _tappe.length,
                                itemBuilder: (context, index) => ListTile(
                                        title: _tappe[index],
                                        key: ObjectKey(_tappe[index].id),

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

                                                final item = _tappe.removeAt(oldIndex);
                                                _tappe.insert(newIndex, item);
                                        });
                                }
                        ),
                        floatingActionButton: FloatingActionButton(
                                onPressed: () {
                                        setState(() {
                                                _tappe.add(TappaPreview());
                                        });
                                },
                                child: Icon(Icons.add)
                        ),
                );
        }
}
