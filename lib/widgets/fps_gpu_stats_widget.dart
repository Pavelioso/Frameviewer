import 'package:TYGOPerformaceViewer/save_system.dart';
import 'package:TYGOPerformaceViewer/styles/style.dart';
import 'package:flutter/material.dart';

class FPSGPU_Stats extends StatefulWidget {
  const FPSGPU_Stats({super.key});

  @override
  State<FPSGPU_Stats> createState() => _FPSGPU_StatsState();
}

class _FPSGPU_StatsState extends State<FPSGPU_Stats> {
  final saveSystem = SaveSystem();
  String minFPS = "-";
  String avgFPS = "-";
  String maxFPS = "-";

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: containerGenericOutlineBG,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FPSStat("LOW FPS", 0),
            FPSStat("AVG FPS", 1),
            FPSStat("HIGH FPS", 2),
          ],
        ),
      ),
    );
  }

  Widget FPSStat(name, double statIndex) {
    String _statValue = (() {
      if (statIndex == 0) {
        return (saveSystem.FPSmin);
      }
      if (statIndex == 1) {
        return (saveSystem.FPSaverage);
      }
      if (statIndex == 2) {
        return (saveSystem.FPSmax);
      }

      return "";
    })();

    Color? _statColor = (() {
      if (statIndex == 0) {
        return (Colors.red);
      }
      if (statIndex == 1) {
        return (Colors.yellow);
      }
      if (statIndex == 2) {
        return (Colors.green);
      }

      return (Colors.black);
    })();

    return Column(
      children: [
        Text(
          name,
          style: TextStyle(color: Colors.white70),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          decoration: containerPronouncedOutlineBG,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text(
              _statValue,
              style: TextStyle(fontSize: 20, color: _statColor),
            ),
          ),
        ),
      ],
    );
  }
}
