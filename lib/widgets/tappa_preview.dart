import 'package:flutter/material.dart';
import 'package:viaggiare/pages/tappa_menu.dart';

class TappaPreview extends StatefulWidget {
        late final UniqueKey id;

        TappaPreview({super.key}) {
                id = UniqueKey();
        }


        @override
        State<TappaPreview> createState() => _TappaPreviewState();
}

class _TappaPreviewState extends State<TappaPreview> {
        @override
        Widget build(BuildContext context) {
                return Row(
                        children: [
                                Expanded(
                                        child: TextField(
                                                decoration: InputDecoration(
                                                        hintText: 'Tappa',
                                                        hintStyle: TextStyle(
                                                                color: Colors.black26
                                                        )
                                                )
                                        )
                                ),
                                IconButton(
                                        onPressed: () {
                                                Navigator.push(
                                                        context,
                                                        MaterialPageRoute<void>(
                                                                builder: (constext) => const TappaMenu()
                                                        )
                                                );
                                        },
                                        icon: CircleAvatar(
                                                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                                                child: Icon(
                                                        Icons.open_in_new,
                                                        color: Colors.black26,
                                                )
                                        )
                                )
                        ]
                );
        }
}
