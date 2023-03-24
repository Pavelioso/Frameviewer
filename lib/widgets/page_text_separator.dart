import 'package:flutter/material.dart';

class PageTextSeparator extends StatelessWidget {
  const PageTextSeparator({super.key, required this.separatorText});

  final String separatorText;

  @override
  Widget build(BuildContext context) {
    return Text(
      separatorText,
      style: TextStyle(
          fontWeight: FontWeight.w300, fontSize: 20, color: Colors.white70),
    );
  }
}
