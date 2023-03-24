import 'package:file_picker/file_picker.dart';

/// A singleton class where the app saves everything.
class SaveSystem {
  // Private constructor
  SaveSystem._privateConstructor();

  // Static instance variable
  static final SaveSystem _instance = SaveSystem._privateConstructor();

  factory SaveSystem() {
    return _instance;
  }

  // Here are saved all the variables, and accessed from other widgets.
  // The detailed version of CSV
  String? pickedCSVFile = null;
  String? pickedCSVFileSummary = null;

  String pickedFile = "No CSV File Selected";
  String CPU = "no data";
  String GPU = "no data";
  String applicationName = "no data";

  double timeTested = 0.0;
  double testStartTime = 0.0;
  double testEndTime = 0.0;
  double averageFPS = 0.0;

  // The summary version of CSV

  List<String> listOfLogFiles = <String>['Select'];
  String selectedLog = "none";
  String FPSaverage = "0";
  String FPSmin = "0";
  String FPSmax = "0";
  String FPS1Percent = "0";
  String FPS5Percent = "0";
  String FPS10Percent = "0";

  String CPUname = "no data";
  String GPU0Name = "no data";
  String GPU1Name = "no data";
  String RAMDetails = "no data";
  String screenResolution = "no data";
  String directX = "no data";
  String OS = "no data";
  String GPUdriver = "no data";

  void printAllSummaryValues() {
    print("...HARDWARE DETAILS...");
    print("CPU: " + CPUname);
    print("GPU0: " + GPU0Name);
    print("GPU1: " + GPU1Name);
    print("RAM: " + RAMDetails);
    print("RES: " + screenResolution);
    print("DirectX: " + directX);
    print("OS: " + OS);
    print("GPU Driver: " + GPUdriver);

    print("...FPS DETAILS...");
    print("Average FPS: " + FPSaverage.toString());
    print("FPS Min: " + FPSmin.toString());
    print("FPS Max: " + FPSmax.toString());
    print("FPS min 1%: " + FPS1Percent.toString());
    print("FPS min 5%: " + FPS5Percent.toString());
    print("FPS min 10%: " + FPS10Percent.toString());
  }

  void myMethod() {
    print('Hello from SaveSystem');
  }
}
