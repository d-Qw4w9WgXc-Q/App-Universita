import 'package:flutter/material.dart';

class CampoTesto extends StatefulWidget {
        const CampoTesto({super.key, this.maxLines = 1, this.maxHeight = 300.0, this.hintText = 'Modifica...', this.controller});

        final int? maxLines;
        final double maxHeight;
        final String hintText;
        final TextEditingController? controller;

        @override
        State<CampoTesto> createState() => _CampoTestoState();
}

class _CampoTestoState extends State<CampoTesto> {
        @override
        Widget build(BuildContext context) {
                return ConstrainedBox(
                        constraints: BoxConstraints(
                                maxHeight: widget.maxHeight
                        ),
                        child: TextField(
                                decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: widget.hintText,
                                        icon: Icon(
                                                Icons.drive_file_rename_outline_rounded,
                                                color: Colors.black38,
                                                size: 24
                                        ),
                                ),
                                controller: widget.controller,
                                maxLines: widget.maxLines
                        )
                );
        }
}
