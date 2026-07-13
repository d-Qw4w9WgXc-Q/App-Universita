import 'package:flutter/material.dart';
import 'package:viaggiare/models/tappa.dart';
import 'package:viaggiare/widgets/tappa_preview.dart';
import 'package:viaggiare/widgets/empty_page.dart';

class TappePage extends StatefulWidget {
        const TappePage({super.key});

        @override
        State<TappePage> createState() => TappePageState();
}


class TappePageState extends State<TappePage> with AutomaticKeepAliveClientMixin {
        final List<TappaPreview> _tappe = [];

        // TODO List<Tappa> get tappe => 

        @override
        Widget build(BuildContext context) {
                super.build(context);
                return Scaffold(
                        appBar: AppBar(
                                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                                title: Text('Tappe'),
                        ),
                        body: _tappe.isEmpty ?
                        EmptyPage(
                                icon: Icons.flag_outlined,
                                text: 'Aggiungi tappe...'
                        ) :
                        ReorderableListView.builder(
                                padding: EdgeInsets.only(bottom: 120),
                                buildDefaultDragHandles: false,
                                itemCount: _tappe.length,
                                itemBuilder: (context, index) => ListTile(
                                        title: _tappe[index],
                                        key: _tappe[index].key,

                                        leading: ReorderableDragStartListener(
                                                index: index,
                                                child: Listener(
                                                        onPointerDown: (_) {
                                                                FocusManager.instance.primaryFocus?.unfocus();
                                                        },
                                                        child:Icon(Icons.drag_handle)
                                                )
                                        ),

                                        contentPadding: EdgeInsets.only(left: 8, right: 4)
                                ),

                                onReorderItem: (int oldIndex, int newIndex) {
                                        setState(() {

                                                final item = _tappe.removeAt(oldIndex);
                                                _tappe.insert(newIndex, item);
                                        });
                                }
                        ),
                        floatingActionButton: Padding(
                                padding: EdgeInsets.only(bottom: 40, right: 6),
                                child: FloatingActionButton(
                                        onPressed: () {
                                                setState(() {
                                                        _tappe.add(TappaPreview(key: UniqueKey()));
                                                });
                                        },
                                        child: Icon(Icons.add)
                                ),
                        )
                );
        }


        @override
        bool get wantKeepAlive => true;
}
