import 'package:TYGOPerformaceViewer/charts/line_chart.dart';
import 'package:TYGOPerformaceViewer/save_system.dart';
import 'package:flutter/material.dart';
import 'package:TYGOPerformaceViewer/csv.dart';
import 'widgets/widgets.dart';

/// Simple view with a graph to show FPS data.
class GPUViewPage extends StatefulWidget {
  const GPUViewPage({
    super.key,
  });

  @override
  State<GPUViewPage> createState() => _GPUViewPageState();
}

class _GPUViewPageState extends State<GPUViewPage> {
  final saveSystem = SaveSystem();
  final csvService = CSVService();

  @override
  Widget build(BuildContext context) {
    if (saveSystem.pickedCSVFile == null) {
      return NoDataScreen();
    } else {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            PageTextSeparator(
              separatorText: "GPU FPS Graph",
            ),
            SizedBox(height: 20),
            //FPSGPU_Stats(),
            SizedBox(height: 20),
            LineChartVis(sourceData: csvService.getFPSandTime(saveSystem.pickedCSVFile!)),
            SizedBox(height: 20),
            //LineChartVis(sourceData: CSVService().createValuesAndTimeFromColumn(23)),
          ],
        ),
      );
    }
  }
}
