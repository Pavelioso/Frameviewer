import 'package:TYGOPerformaceViewer/csv.dart';
import 'package:TYGOPerformaceViewer/performance_view_gpu.dart';
import 'package:TYGOPerformaceViewer/performance_view_report.dart';
import 'package:TYGOPerformaceViewer/widgets/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:TYGOPerformaceViewer/save_system.dart';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';

// This is the main container that holds performance view and holds performace view gpu and report.
// Also contains all logic.

// Colors for texts and boxes.
Color primaryTextColor = Colors.white;
Color secondaryTextColor = Colors.white54;

class PerformanceView extends StatefulWidget {
  const PerformanceView({super.key});

  @override
  State<PerformanceView> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<PerformanceView> {
  FilePickerResult? pickedFile;
  String? pickedCSV;

  final saveSystem = SaveSystem();
  final csvService = CSVService();

  @override
  void initState() {
    print("Starting App");
    super.initState();
  }

  /// Function used to appened correct directors to when assets are loaded. Used with strings.
  String webPath(str) {
    return (kIsWeb) ? 'assets/$str' : str;
  }

  /// Load a CSV function that is called from a button. Responsible for opening a explorer window, loading in large csv file with frame by frame data.
  Future<void> loadCSV() async {
    saveSystem.pickedCSVFile = await pickFileHtml();
    processCSVFile();
  }

  /// Load a CSV function that is called from a button. Responsible for opening a explorer window, loading in summary csv file.
  Future<void> loadCSVSummary() async {
    saveSystem.pickedCSVFileSummary = await pickFileHtml();
    processCSVFileSummary();
  }

  /// Loads a dummy CSV into the app, for testing purposes.
  Future<void> loadDummyCSV() async {
    try {
      print("Trying to open witcher 3 SCV.");
      final response1 = await html.HttpRequest.request(webPath("assets/witcher_3_gdrive.csv"));
      final content1 = await response1.responseText;

      final response2 = await html.HttpRequest.request(webPath("assets/FrameView_Summary_gdrive.csv"));
      final content2 = await response2.responseText;

      saveSystem.pickedFile = "witcher_3_gdrive.csv";

      saveSystem.pickedCSVFile = content1;
      saveSystem.pickedCSVFileSummary = content2;

      await processCSVFile();
      await processCSVFileSummary();
    } catch (e) {
      print("An exeption occured: $e");
    }
    return;
  }

  /// Processes a CSVString and loads its contents into SaveSystem (SaveSystem holds all values which can be accessed by other widgets).
  Future<void> processCSVFile() async {
    // Get times and time of testing.
    String testEndTimeAsString = await csvService.getLastValueInColumn(12);
    saveSystem.testEndTime = await double.parse(testEndTimeAsString);
    String startEndTimeAsString = await csvService.getSpecificTileFromCSV(1, 12);
    saveSystem.testStartTime = await double.parse(startEndTimeAsString);
    double timeTestedUnformatted = saveSystem.timeTested = saveSystem.testEndTime - saveSystem.testStartTime;
    double timeTestedFormatted = num.parse(timeTestedUnformatted.toStringAsFixed(2)) as double;
    saveSystem.timeTested = timeTestedFormatted;

    // Refresh App
    setState(() {});
  }

  Future<void> processCSVFileSummary() async {
    List<String> data = await csvService.getColumnFromCSV(saveSystem.pickedCSVFileSummary, 0);
    List<String> firstButton = <String>[
      "Select"
    ]; // The first value of the drop down has to be all the time same for some reason, otherwise app crashes.
    List<String> buttonList = firstButton + data;

    saveSystem.listOfLogFiles = await buttonList;
    print(saveSystem.listOfLogFiles);

    setState(() {});
  }

  // A callback function that is called by a button that let's use select different logs.
  Future<void> updateContentForCSVSummary(String value) async {
    print("Updating content for: " + value);
    List<String>? summaryRowValues = await csvService.getRowFromCSV(saveSystem.pickedCSVFileSummary, value);

    String? _getValue(int index) {
      return csvService.getValueFromListByIndex(summaryRowValues, index);
    }

    String? text = await csvService.getValueFromListByIndex(summaryRowValues, 2);
    print(text);
    saveSystem.FPSaverage = _getValue(8)!;

    // FPS Data
    saveSystem.FPSmin = _getValue(12)!;
    saveSystem.FPSmax = _getValue(13)!;
    saveSystem.FPS1Percent = _getValue(15)!;
    saveSystem.FPS5Percent = _getValue(18)!;
    saveSystem.FPS10Percent = _getValue(19)!;

    // Hardware Data

    saveSystem.CPUname = _getValue(5)!;
    saveSystem.GPU0Name = _getValue(3)!;
    saveSystem.GPU1Name = _getValue(4)!;
    saveSystem.GPUdriver = _getValue(44)!;
    saveSystem.RAMDetails = _getValue(46)!;
    saveSystem.screenResolution = _getValue(6)!;
    saveSystem.OS = _getValue(43)!;
    saveSystem.directX = _getValue(7)!;

    saveSystem.printAllSummaryValues();
    //String? text = await csvService.getValueFromCSVbyName(saveSystem.pickedCSVFileSummary, value, "Application");
    //print(text);
    setState(() {});
  }

  /// Opens window diaglog (works for html - web apps) and processes the CSV data as a string.
  Future<String> pickFileHtml() async {
    // Create an input element
    final input = html.FileUploadInputElement();
    input.accept = '.csv'; // Accept only CSV.

    // Trigger the file picker dialog
    input.click();

    // Wait for the user to select a file
    await input.onChange.first;

    // Read the contents of the selected file
    final file = input.files!.first;
    final reader = html.FileReader();
    SaveSystem().pickedFile = file.name;
    //print(file.name);
    reader.readAsText(file);
    await reader.onLoad.first;
    final fileContents = reader.result as String;

    // Return the selected file
    return fileContents;
  }

  // Opens window dialog to select file, processes the file. Usable in the future for mobile or desktop app. Did not work on Firebase hosted webapp.
  /* Future pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    //print(result?.files.first.bytes);
    if (result != null) {
      //print(result?.files.first.bytes);
      print(result.files.single.extension);
      print(result.names.first);
      SaveSystem().pickedCSVFile = await CSVService().convertFileToCSVString(result);
      SaveSystem().pickedFile = await result.names.first.toString();
      SaveSystem().CPU = await CSVService().getSpecificTileFromCSV(SaveSystem().pickedCSVFile!, 1, 2);
      SaveSystem().GPU = await CSVService().getSpecificTileFromCSV(SaveSystem().pickedCSVFile!, 1, 1);
      SaveSystem().applicationName = await CSVService().getSpecificTileFromCSV(SaveSystem().pickedCSVFile!, 1, 0);
      SaveSystem().resolution = await CSVService().getSpecificTileFromCSV(SaveSystem().pickedCSVFile!, 1, 3);

      //print(await CSVService().getColumnFromCSV(pickedCSV!, 6));
      //await getSpecificTileFromCSV(pickedCSV!, 5, 1);
      setState(() {});
      //print(await CSVService().getSpecificTileFromCSV(SaveSystem().pickedCSVFile!, 1, 2));
    } else {
      throw "Cancelled File Picker";
    }
  } */

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: loadCSV,
                    child: Text('Load a CSV'),
                  ),
                ),
                SizedBox(width: 20),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: loadCSVSummary,
                    child: Text('Load a CSV Summary'),
                  ),
                ),
                SizedBox(width: 20),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: loadDummyCSV,
                    child: Text('Load Dummy CSV'),
                  ),
                ),
                SizedBox(width: 20),
                SizedBox(
                  width: 200,
                  child: DropdownButtonExample(onOptionSelected: updateContentForCSVSummary),
                ),
                SizedBox(width: 20),
                Text(
                  SaveSystem().pickedFile,
                  style: TextStyle(color: primaryTextColor, fontSize: 30, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text(
                  "To load correct CSV: First button is for larger CSV file, that contains frame by frame data. Second button is for Summary CSV file, where different tests can be selected on the right.",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                SizedBox(height: 5),
                Text(
                  "When everything is loaded, select correct log inside of the dropdown button.",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                SizedBox(height: 5),
              ],
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.ideographic,
              children: [
                Text("Tested for duration : ", style: TextStyle(color: secondaryTextColor)),
                SizedBox(width: 10),
                Text(SaveSystem().timeTested.toString() + " seconds.", style: TextStyle(color: primaryTextColor, fontSize: 18)),
              ],
            ),
            SizedBox(height: 20),
            Flexible(child: MyTabView()), // Needs to be in flexible to solve overflowing issues.
          ],
        ),
      ),
    );
  }
}

class MyTabView extends StatefulWidget {
  @override
  _MyTabViewState createState() => _MyTabViewState();
}

class _MyTabViewState extends State<MyTabView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2); // length is the number of tabs
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            //color: Colors.grey[200],
            border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              //labelColor: Colors.blueAccent,
              indicatorWeight: 5,
              indicatorColor: Colors.blue,
              isScrollable: true,
              controller: _tabController,
              tabs: [
                Tab(
                    child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "REPORT",
                    textAlign: TextAlign.left,
                  ),
                )),
                Tab(text: 'GPU'),

                //Tab(text: 'GTX 1080'),
              ],
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              FullReportPage(),
              GPUViewPage(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
