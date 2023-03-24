import 'package:TYGOPerformaceViewer/save_system.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:TYGOPerformaceViewer/csv.dart';
import '../styles/style.dart';

class LineChartVis extends StatefulWidget {
  const LineChartVis({
    super.key,
    required this.sourceData,
  });

  final Future<List<dynamic>> sourceData;

  @override
  State<LineChartVis> createState() => _LineChartVisState();
}

class _LineChartVisState extends State<LineChartVis> {
  final csvService = CSVService();
  final saveSystem = SaveSystem();

  List<Color> gradientColors = [
    Colors.blue,
    Colors.cyan,
  ];

  bool showAvg = false;
  List<FlSpot> chartLineData = [];

  @override
  void initState() {
    super.initState();

    // Seach for data and create the statistic only when CSV file is present.
    updateData();
  }

  void updateData() async {
    chartLineData = await csvService.createLineChartDataF(widget.sourceData);
    //print("chartLineData");

    setState(() {});
    //print(chartLineData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: containerGenericOutlineBG,
      child: SizedBox(
          height: 500,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: lineChartMain(),
          )),
    );
  }

  Widget lineChartMain() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            right: 18,
            left: 12,
            top: 24,
            bottom: 12,
          ),
          child: LineChart(
            mainData(), //Delete this to get avg data back on the bottom.
            //showAvg ? avgData() : mainData(),
          ),
        ),
        /*  SizedBox(
          width: 60,
          height: 34,
          child: TextButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Text(
              'avg',
              style: TextStyle(
                fontSize: 12,
                color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
              ),
            ),
          ),
        ), */
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    // These are the bottom values, they increment by one second. I've put in a simple if statement otherwise
    // fl_charts puts out start value and end value, which visually goes over already present time values.

    if (value == saveSystem.testStartTime || value == saveSystem.testEndTime) {
      return Text("");
    } else {
      return Text(
        value.toString(),
        style: TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.normal,
          fontSize: 10,
        ),
      );
    }
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.normal,
      color: Colors.white70,
      fontSize: 10,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '0 FPS';
        break;
      case 50:
        text = '50 FPS';
        break;
      case 100:
        text = '100 FPS';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 50,
        verticalInterval: 5,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.white70,
            strokeWidth: 0.5,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.white38,
            strokeWidth: 0.5,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      //minX: saveSystem.testStartTime,
      //maxX: saveSystem.testEndTime,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: chartLineData,
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
            ),
          ),
        ),
      ],
    );
  }

  /* LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  } */
}
