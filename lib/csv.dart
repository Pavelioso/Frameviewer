import 'dart:convert';
import 'package:TYGOPerformaceViewer/save_system.dart';
import 'package:csv/csv.dart';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';

class CSVService {
  final saveSystem = SaveSystem();

  /// Gets all values from one column and returns it as list of strings.
  Future<List<String>> getColumnFromCSV(String? csv, int columnIndex) async {
    final fileData = csv;
    List<List<dynamic>> rowsAsListOfValues = CsvToListConverter().convert(fileData);
    rowsAsListOfValues.removeAt(0);
    List<String> columnValues = [];
    for (var row in rowsAsListOfValues) {
      columnValues.add(row[columnIndex].toString());
    }
    return columnValues;
  }

  Future<List<String>?> getRowFromCSV(String? csv, String searchValue) async {
    final fileData = csv;
    List<List<dynamic>> rowsAsListOfValues = CsvToListConverter().convert(fileData);

    for (var row in rowsAsListOfValues) {
      if (row[0].toString() == searchValue) {
        List<String> rowValuesAsStringList = row.map((dynamic value) => value.toString()).toList();
        return rowValuesAsStringList;
      }
    }

    // Return null if row not found
    return null;
  }

  /// Not working properly, but saving it for later, purpose was to be able to search by column and row names.
  Future<String?> getValueFromCSVbyName(String? csv, String rowName, String columnName) async {
    final fileData = csv;
    List<List<dynamic>> rowsAsListOfValues = CsvToListConverter().convert(fileData);

    // Find the index of the column to search
    int columnIndex = -1;
    if (rowsAsListOfValues.isNotEmpty) {
      List<dynamic> headerRow = rowsAsListOfValues.first;
      columnIndex = headerRow.indexOf(columnName);
    }

    if (columnIndex != -1) {
      for (var row in rowsAsListOfValues) {
        if (row[0].toString() == rowName && row[columnIndex].toString() == columnName) {
          return row[columnIndex].toString();
        }
      }
    }

    // Return null if row or column not found
    return null;
  }

  /// Function to find a value inside of a list of strings, used mostly to find a value in already parsed data from a row or column of table.
  String? getValueFromListByIndex(List<String>? list, int index) {
    if (list != null) {
      String selected = list[index];
      return selected;
    }

    return null;
  }

  ///  Gets specific value from set coordinates. Usefull for getting names of columns, or CPU name.
  Future<String> getSpecificTileFromCSV(int column, int row) async {
    final fileData = saveSystem.pickedCSVFile;
    List<List<dynamic>> csvTable = CsvToListConverter().convert(fileData);
    return (csvTable[column][row].toString());
  }

  /// Only prints to console CSV values in column, for debug purposes.
  Future<void> readCSVColumn(String? csv) async {
    List<String> columnValues = await getColumnFromCSV(csv, 1);
    for (var value in columnValues) {
      print(value);
    }
  }

  /// Gets GPU model.
  Future<String> getGPU() async {
    Future<String> GPUname = getSpecificTileFromCSV(1, 1);
    return (GPUname);
  }

  /// Gets CPU model.
  Future<String> getCPU() async {
    Future<String> CPUname = getSpecificTileFromCSV(1, 2);
    return (CPUname);
  }

  /// Gets all values of FPS, since the FPS is not present in the CSV, it has to be calculated, this method is used further in other methods.
  Future<List<double>> getFPSValues(String? csv) async {
    List<String> msBetweenPresents = await getColumnFromCSV(csv, 13); //13

    List<double> msBetweenPresentsDouble = msBetweenPresents.map((str) => double.parse(str)).toList();

    List<double> FPS = msBetweenPresentsDouble.map((value) => (1000 / value).toStringAsFixed(1)).map((str) => double.parse(str)).toList();

    return (FPS);
  }

  /// Gets the average value of all the average FPS values.
  Future<double> getAverageFPS(csv) async {
    List<double> doubleList = await getFPSValues(csv);
    double averagePure = doubleList.reduce((a, b) => a + b) / doubleList.length;
    double averageFormatted = num.parse(averagePure.toStringAsFixed(2)) as double;

    return averageFormatted;
  }

  /// Gets the directX string from the CSV.
  Future<String> getDirectX(csv) async {
    return getSpecificTileFromCSV(1, 4);
  }

  /// Gets all the values in the Time column, and returns them as double of list.
  Future<List<double>> getTime(String? csv) async {
    List<String> timeInSeconds = await getColumnFromCSV(csv, 12);
    List<double> timeInSecondsDouble = timeInSeconds.map((str) => double.parse(str)).toList();
    return (timeInSecondsDouble);
  }

  // Get FPS and Time, combines it into a list, used for charts.
  Future<List<dynamic>> getFPSandTime(String csv) async {
    List<double> list1 = await getFPSValues(csv);
    List<double> list2 = await getTime(csv);
    List<dynamic> zipped = IterableZip([list1, list2]).toList();
    return (zipped);
  }

  // Create list of values combined with time that can be used for charts.
  Future<List<dynamic>> createValuesAndTimeFromColumn(String? data, int columnIndex) async {
    List<String> listOfValues = await getColumnFromCSV(data, columnIndex);
    List<double> list1 = listOfValues.map((str) => double.parse(str)).toList();
    List<double> list2 = await getTime(data);
    List<dynamic> zipped = IterableZip([list1, list2]).toList();
    return (zipped);
  }

  // Gets last value from a specified column, usefull for example to get last value of "time in seconds" to get time reference.
  Future<String> getLastValueInColumn(int columnIndex) async {
    List<List<dynamic>> rows = CsvToListConverter().convert(saveSystem.pickedCSVFile);
    dynamic lastValue = rows.last[columnIndex];
    return (lastValue.toString());
  }

  /// Takes a file from a file_picker and converts it into a CSV string. Cannot be used for WEB because file_picker does not work for web.
  Future<String?> convertFileToCSVString(FilePickerResult) async {
    if (FilePickerResult != null && FilePickerResult!.files.isNotEmpty) {
      final bytes = FilePickerResult!.files.first.bytes;
      if (bytes != null) {
        final csvString = utf8.decode(bytes);
        return (csvString);
      } else {
        throw Exception("Failed to convert file to CSV String. Bytes are null.");
      }
    } else {
      throw Exception("Failed to convert file to CSV String. Bytes are null.");
    }
  }

  /// Creates Line Chart data for LineChartVis. You can reference a function as a data source for the points to be made from, like "getFPSandTime".
  Future<List<FlSpot>> createLineChartDataF(Future<List<dynamic>> inputData) async {
    List<dynamic> dataValues = await inputData;
    {
      List<FlSpot> chartData = [];
      for (var d in dataValues) {
        chartData.add(FlSpot(d[1], d[0]));
      }

      //print(chartData);
      return (chartData);
    }
  }
}
