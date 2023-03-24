import 'package:TYGOPerformaceViewer/charts/bar_chart.dart';
import 'package:TYGOPerformaceViewer/save_system.dart';
import 'package:flutter/material.dart';
import 'widgets/widgets.dart';

class FullReportPage extends StatefulWidget {
  const FullReportPage({super.key});

  @override
  State<FullReportPage> createState() => _FullReportPageState();
}

class _FullReportPageState extends State<FullReportPage> {
  final saveSystem = SaveSystem();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FPSGPU_Stats(),
              SizedBox(height: 20),
              PageTextSeparator(separatorText: 'Base Hardware'),
              SizedBox(height: 20),
              Wrap(
                runSpacing: 40,
                spacing: 40,
                children: [
                  HardwareWidget(
                    hardwareName: "CPU",
                    hardwareDetails: saveSystem.CPUname,
                  ),
                  HardwareWidget(
                    hardwareName: "GPU0",
                    hardwareDetails: saveSystem.GPU0Name,
                  ),
                  HardwareWidget(
                    hardwareName: "GPU1",
                    hardwareDetails: saveSystem.GPU1Name,
                  ),
                  HardwareWidget(
                    hardwareName: "RAM",
                    hardwareDetails: saveSystem.RAMDetails,
                  ),
                  HardwareWidget(
                    hardwareName: "RESOLUTION",
                    hardwareDetails: saveSystem.screenResolution,
                  ),
                  HardwareWidget(
                    hardwareName: "DirectX",
                    hardwareDetails: saveSystem.directX,
                  ),
                  HardwareWidget(
                    hardwareName: "OS",
                    hardwareDetails: saveSystem.OS,
                  ),
                  HardwareWidget(
                    hardwareName: "GPU Driver",
                    hardwareDetails: saveSystem.GPUdriver,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          PageTextSeparator(separatorText: 'GPU FPS Statistics'),
          SizedBox(height: 20),
          Wrap(
            runSpacing: 40,
            spacing: 40,
            children: [
              HardwareWidget(
                hardwareName: "Average FPS",
                hardwareDetails: saveSystem.FPSaverage,
              ),
              HardwareWidget(
                hardwareName: "Min FPS",
                hardwareDetails: saveSystem.FPSmin,
              ),
              HardwareWidget(
                hardwareName: "Max FPS",
                hardwareDetails: saveSystem.FPSmax,
              ),
              HardwareWidget(
                hardwareName: "Min 1% FPS",
                hardwareDetails: saveSystem.FPS1Percent,
              ),
              HardwareWidget(
                hardwareName: "Min 5% FPS",
                hardwareDetails: saveSystem.FPS5Percent,
              ),
              HardwareWidget(
                hardwareName: "Min 10% FPS",
                hardwareDetails: saveSystem.FPS10Percent,
              ),
            ],
          ),
          SizedBox(height: 20),

          /* Container(
            decoration: containerGenericOutlineBG,
            child: SizedBox(
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: BarChartVis(),
                )),
          ), */
          SizedBox(height: 20),
          Text(
            "GPU Statistics",
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20, color: Colors.white70),
          ),
          SizedBox(height: 20),
          BarChartVis(),
        ],
      ),
    );
  }
}
