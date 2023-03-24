# nVidia Frameviewer

Frameviewer is a simple web app view GPU statistics in CSV format, exported from benchmarking software, nVidia Frameview. 
There is no proprietary solution from nVidia, so this is my take on it. 

## Getting Started:

This is the web app [Frameviewer](https://frameviewer-d74b1.web.app/#/).
It's limited with features, but it gets the job done. 

## Usability:

The exported CSV files have to go through some other software to correct its format. For example import to Google Drive, and export, and it will be fixed.
I haven't found a solution how to fix it inside the app yet. 

The first button is for the larger CSV file, usually called but seeming random string of numbers. The second button is to select a summary CSV. Then, in the dropdown menu, select which test in summary you want. 

## Problems:
This is my first app, to learn Flutter. It doesn't have animations, too many graphs lag so I put in only one. I also wanted to make the graph zoomable, but haven't figured out how yet. 
The app works only on web. 
