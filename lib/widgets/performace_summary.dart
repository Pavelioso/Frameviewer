import 'package:flutter/material.dart';

class PerformaceSummary extends StatefulWidget {
  const PerformaceSummary({super.key});

  @override
  State<PerformaceSummary> createState() => _PerformaceSummaryState();
}

class _PerformaceSummaryState extends State<PerformaceSummary> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(255, 37, 37, 37),
            border: Border.all(
              color: Color.fromARGB(255, 46, 46, 46),
              width: 1,
            )));
  }
}
