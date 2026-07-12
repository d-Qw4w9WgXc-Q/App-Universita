import 'package:flutter/material.dart';
import 'package:viaggiare/widgets/checklist_punto.dart';
import 'package:viaggiare/widgets/empty_page.dart';

class ChecklistPage extends StatefulWidget {
        const ChecklistPage({super.key});

        @override
        State<ChecklistPage> createState() => ChecklistPageState();
}

class ChecklistPageState extends State<ChecklistPage> with AutomaticKeepAliveClientMixin {
        final List<ChecklistPunto> _punti = [];

        @override
        Widget build(BuildContext context) {
                super.build(context);
                return Scaffold(
                        appBar: AppBar(
                                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                                title: Text('Checklist'),
                        ),
                        body: _punti.isEmpty?
                        EmptyPage(
                                icon: Icons.check_box_outlined,
                                text: 'Aggiungi punti...'
                        ) :
                        ReorderableListView.builder(
                                padding: EdgeInsets.only(bottom: 200),
                                buildDefaultDragHandles: false,
                                itemCount: _punti.length,
                                itemBuilder: (context, index) => ListTile(
                                        title: _punti[index],
                                        key: _punti[index].key,

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

                                                final item = _punti.removeAt(oldIndex);
                                                _punti.insert(newIndex, item);
                                        });
                                }
                        ),
                        floatingActionButton: Padding(
                                padding: EdgeInsets.only(bottom: 40, right: 6),
                                child: Column(
                                        mainAxisAlignment: .end,
                                        children: [
                                                FloatingActionButton(
                                                        onPressed: () {
                                                                setState(() {
                                                                        _punti.add(ChecklistPunto(key: UniqueKey()));
                                                                });
                                                        },
                                                        child: Icon(Icons.add)
                                                )
                                        ]
                                )
                        )
                );
        }

        @override
        bool get wantKeepAlive => true;
}
