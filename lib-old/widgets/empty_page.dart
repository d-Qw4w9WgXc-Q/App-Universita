import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
        const EmptyPage({super.key, required this.icon, required this.text, this.bottomOffset=100});

        final IconData icon;
        final String text;
        final double bottomOffset;

        @override
        Widget build(BuildContext context) {
                return Center(
                        child: Padding(
                                padding:EdgeInsets.only(bottom: bottomOffset),
                                child: Column (
                                        mainAxisAlignment: .center,
                                        children: [
                                                Icon(
                                                        icon,
                                                        color: Colors.black38,
                                                        size: 120
                                                ),
                                                Text(
                                                        text,
                                                        style: TextStyle(
                                                                color: Colors.black38
                                                        )
                                                )
                                        ]
                                )
                        )
                );
        }
}
