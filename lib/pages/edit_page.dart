import 'package:flutter/material.dart';
import 'package:viaggiare/models/viaggio.dart';
import 'package:viaggiare/pages/tappe_page.dart';
import 'package:viaggiare/pages/viaggio_page.dart';
import 'package:viaggiare/pages/checklist_page.dart';

class EditPage extends StatefulWidget {
        const EditPage({super.key, required this.onSave});

        final Function({required Viaggio viaggio}) onSave;

        @override
        State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> with TickerProviderStateMixin {

        late PageController _pageViewController;
        late TabController _tabController;
        int _pageIndex = 0;
        int get pageIndex => _pageIndex;

        final GlobalKey<ViaggioPageState> _viaggioKey = GlobalKey();
        final GlobalKey<TappePageState> _tappeKey = GlobalKey();
        final GlobalKey<ChecklistPageState> _checklistKey = GlobalKey();

        @override
        void initState() {
                super.initState();
                _pageViewController = PageController();
                _tabController = TabController(length: 3, vsync: this);
        }

        @override
        void dispose() {
                super.dispose();
                _pageViewController.dispose();
                _tabController.dispose();
        }


        @override
        Widget build(BuildContext context) {
                return Scaffold(
                        body: Stack(
                                alignment: .bottomCenter,
                                children: [
                                        PageView(
                                                controller: _pageViewController,
                                                onPageChanged: _handlePageViewChanged,
                                                children: [
                                                        ViaggioPage(key: _viaggioKey),
                                                        TappePage(key: _tappeKey),
                                                        ChecklistPage(key: _checklistKey)
                                                ]
                                        ),
                                        Padding(
                                                padding: EdgeInsets.only(bottom: 20),
                                                child: TabPageSelector(
                                                        controller: _tabController,
                                                        color: Theme.of(context).colorScheme.surface,
                                                        selectedColor: Theme.of(context).colorScheme.primary,
                                                )
                                        )
                                ]
                        ),
                        floatingActionButton: FloatingActionButton(
                                heroTag: 'edit_save',
                                onPressed: () {
                                        Viaggio? viaggio = _viaggioKey.currentState?.viaggio;

                                        if(viaggio != null && viaggio.titolo != '') {

                                                // TODO salva nel database usando le key per accedere ai membri

                                                widget.onSave(viaggio: viaggio);
                                                Navigator.pop(context);
                                        }
                                },
                                child: Icon(Icons.save)
                        ),
                        floatingActionButtonLocation: .startFloat
                );
        }

        void _handlePageViewChanged(int currentPageIndex) {
                _tabController.index = currentPageIndex;
                setState(() {
                        _pageIndex = currentPageIndex;
                });
        }

}
