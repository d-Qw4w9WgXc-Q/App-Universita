import 'package:flutter/material.dart';
import 'package:viaggiare/models/viaggio.dart';

class ViaggioPreview extends StatelessWidget {
        const ViaggioPreview({super.key, required this.viaggio});

        final Viaggio viaggio;

        @override
        Widget build(BuildContext context) {
                return Column(
                        mainAxisAlignment: .end,
                        crossAxisAlignment: .start,
                        children: [
                                Text(
                                        viaggio.titolo,
                                        style: TextStyle(
                                                fontSize: 20
                                        )
                                ),
                                Text(
                                        viaggio.descrizione ?? '',
                                        maxLines: 1,
                                        overflow: .fade,
                                        style: TextStyle(
                                                color: Colors.black38
                                        )
                                )
                        ]
                );
        }
}
