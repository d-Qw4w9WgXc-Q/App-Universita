import 'package:flutter/material.dart';

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
                return TextField(
                        decoration: InputDecoration(
                                hintText: 'Tappa',
                                hintStyle: TextStyle(
                                        color: Colors.black26
                                )
                        )
                );
        }
}
