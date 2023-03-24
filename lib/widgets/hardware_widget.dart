import 'package:TYGOPerformaceViewer/save_system.dart';
import 'package:TYGOPerformaceViewer/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:TYGOPerformaceViewer/performace_view.dart';

class HardwareWidget extends StatelessWidget {
  const HardwareWidget({
    super.key,
    this.hardwareName = "CPU",
    this.hardwareDetails = "No Data",
  });

  final String hardwareName;
  final String hardwareDetails;

  //final saveSystem = SaveSystem();
  final String hellothere = "heelo";

  //final Icon hardwareIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: containerGenericOutlineBG,
      child: HardwareContent(),
    );
  }

  Widget HardwareContent() {
    return SizedBox(
      width: 200,
      height: 140,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 50,
            child: Icon(
              Icons.computer,
              color: Colors.blue,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Text(
                hardwareName,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Container(
                  width: 140, // Set the width of the container to 200 pixels
                  child: Text(
                    hardwareDetails,
                    maxLines: 5, // Set the maximum number of lines to 2
                    overflow: TextOverflow.ellipsis, // Add an ellipsis if the text overflows
                    style: TextStyle(color: Colors.white70, fontWeight: FontWeight.normal),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
