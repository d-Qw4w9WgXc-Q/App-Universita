import 'package:flutter/material.dart';

class ChecklistPunto extends StatefulWidget {

        const ChecklistPunto({super.key});

        @override
        State<ChecklistPunto> createState() => _ChecklistPuntoState();
}

class _ChecklistPuntoState extends State<ChecklistPunto> {
        bool _checked = false;
        bool get checked => _checked;

        @override
        Widget build(BuildContext context) {
                return Row(
                        children: [
                                Expanded(
                                        child: TextField(
                                                decoration: InputDecoration(
                                                        hintText: 'Da fare...',
                                                        hintStyle: TextStyle(
                                                                color: Colors.black26
                                                        )
                                                )
                                        )
                                ),
                                Checkbox(
                                        value: _checked,
                                        onChanged: (bool? newValue) {
                                                setState(() {
                                                        _checked = newValue ?? false;
                                                        }
                                                );
                                        }
                                ),
                        ]
                );
        }
}
