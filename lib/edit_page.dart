import 'package:flutter/material.dart';
import 'tappe_page.dart';
import 'viaggio_page.dart';
import 'checklist_page.dart';

class EditPage extends StatefulWidget {
        const EditPage({super.key});

        @override
        State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> with TickerProviderStateMixin {

        late PageController _pageViewController;
        late TabController _tabController;
        int _pageIndex = 0;
        int get pageIndex => _pageIndex;

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
                return Stack(
                        alignment: .bottomCenter,
                        children: [
                                PageView(
                                        controller: _pageViewController,
                                        onPageChanged: _handlePageViewChanged,
                                        children: [
                                                ViaggioPage(),
                                                TappePage(),
                                                ChecklistPage()
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
                );
        }

        void _handlePageViewChanged(int currentPageIndex) {
                _tabController.index = currentPageIndex;
                setState(() {
                        _pageIndex = currentPageIndex;
                });
        }

}
